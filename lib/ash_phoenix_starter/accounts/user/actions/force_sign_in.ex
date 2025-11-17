defmodule AshPhoenixStarter.Accounts.User.Actions.ForceSignIn do
  use Ash.Resource.Actions.Implementation
  alias AshPhoenixStarter.Accounts.User
  alias AshAuthentication.Jwt

  def run(inputs, _opts, _context) do
    conn = inputs.arguments.conn
    purpose = inputs.arguments.purpose
    user_id = inputs.arguments.user_id
    user = Ash.get!(User, user_id, authorize?: false)

    # Generate sign-in token for target user (no password needed)
    {:ok, token, _claims} = Jwt.token_for_user(user, %{"purpose" => purpose})
    to_sign_in_user = Ash.Resource.put_metadata(user, :token, token)

    conn =
      conn
      |> AshAuthentication.Plug.Helpers.store_in_session(to_sign_in_user)
      |> Plug.Conn.assign(:current_user, to_sign_in_user)

    {:ok, conn}
  end
end
