defmodule AshPhoenixStarterWeb.AuthController do
  use AshPhoenixStarterWeb, :controller
  use AshAuthentication.Phoenix.Controller

  def success(conn, activity, user, _token) do
    return_to = get_session(conn, :return_to) || ~p"/dashboard"

    message =
      case activity do
        {:confirm_new_user, :confirm} -> "Your email address has now been confirmed"
        {:password, :reset} -> "Your password has successfully been reset"
        _ -> "You are now signed in"
      end

    conn
    |> delete_session(:return_to)
    |> store_in_session(user)
    # If your resource has a different name, update the assign name here (i.e :current_admin)
    |> assign(:current_user, user)
    |> put_flash(:info, message)
    |> redirect(to: return_to)
  end

  def failure(conn, activity, reason) do
    message =
      case {activity, reason} do
        {_,
         %AshAuthentication.Errors.AuthenticationFailed{
           caused_by: %Ash.Error.Forbidden{
             errors: [%AshAuthentication.Errors.CannotConfirmUnconfirmedUser{}]
           }
         }} ->
          """
          You have already signed in another way, but have not confirmed your account.
          You can confirm your account using the link we sent to you, or by resetting your password.
          """

        _ ->
          "Incorrect email or password"
      end

    conn
    |> put_flash(:error, message)
    |> redirect(to: ~p"/sign-in")
  end

  def sign_out(conn, _params) do
    return_to = get_session(conn, :return_to) || ~p"/"

    conn
    |> clear_session(:AshPhoenixStarter)
    |> put_flash(:info, "You are now signed out")
    |> redirect(to: return_to)
  end

  def impersonate(conn, %{"user_id" => user_id}) do
    # 1. Prevent unauthorized cross tenant access
    current_user = conn.assigns.current_user

    if AshPhoenixStarterWeb.Helpers.is_super_user?(current_user) do
      # Store original session token for reversion
      # Ash stores under "user_token" by default (confirm if customized)
      conn
      # Sign in as the target user
      |> force_sign_in(user_id, "Impersonate user_id: #{user_id}", true)
      |> put_flash(:info, "Now impersonating")
      |> put_session(:impersonator_user_id, current_user.id)
      |> redirect(to: ~p"/dashboard")
    else
      conn
      |> put_flash(:error, "You are not allowed to impersonate other users")
      |> redirect(to: ~p"/dashboard")
    end
  end

  def stop_impersonating(conn, _params) do
    current_user_id = get_session(conn, :impersonator_user_id, false)

    if current_user_id do
      # Restore original user session
      conn
      |> force_sign_in(current_user_id, "Stop impersonatation", false)
      |> delete_session(:impersonator_user_id)
      |> put_flash(:info, "Impersonation ended. Back to your account.")
      |> redirect(to: ~p"/dashboard")
    else
      conn
      |> put_flash(:error, "No impersonation active.")
      |> redirect(to: ~p"/dashboard")
    end
  end

  def force_sign_in(conn, user_id, purpose, impersonated? \\ true) do
    alias AshAuthentication.Jwt
    target_user = Ash.get!(AshPhoenixStarter.Accounts.User, user_id, authorize?: false)

    # Generate sign-in token for target user (no password needed)
    {:ok, token, _claims} = Jwt.token_for_user(target_user, %{"purpose" => purpose})

    to_sign_in_user =
      target_user
      |> Ash.Resource.put_metadata(:token, token)
      |> Ash.Resource.put_metadata(:impersonated?, impersonated?)

    conn
    |> store_in_session(to_sign_in_user)
    |> assign(:current_user, to_sign_in_user)
  end
end
