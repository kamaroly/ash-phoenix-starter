defmodule AshPhoenixStarterWeb.Controllers.AuthControllerTest do
  use AshPhoenixStarterWeb.ConnCase
  alias AshPhoenixStarter.Accounts.User

  describe "impersonate/2" do
    test "impersonates user", %{conn: conn} do
      current_user = create_user()
      super_user_conn = login(conn, current_user)

      # Ensure the user is in the super_users list to allow impersonation
      Application.put_env(:AshPhoenixStarter, :super_users, [to_string(current_user.email)])

      {:ok, team_member} =
        Ash.create(User, %{email: "John@example.com"},
          action: :invite,
          actor: current_user,
          authorize?: false
        )

      # Attempt impersonation
      impersonated_conn = get(super_user_conn, ~p"/accounts/users/impersonate/#{team_member.id}")

      refute impersonated_conn.private.plug_session["user_token"] ==
               super_user_conn.private.plug_session["user_token"]
    end

    test "denies impersonation if the user is not among super users", %{conn: conn} do
      current_user = create_user()
      super_user_conn = login(conn, current_user)

      {:ok, team_member} =
        Ash.create(User, %{email: "John@example.com"},
          action: :invite,
          actor: current_user,
          authorize?: false
        )

      # Attempt impersonation
      impersonated_conn = get(super_user_conn, ~p"/accounts/users/impersonate/#{team_member.id}")

      # TODO: Retrieve user by token
      assert impersonated_conn.private.plug_session["user_token"] ==
               super_user_conn.private.plug_session["user_token"]
    end
  end
end
