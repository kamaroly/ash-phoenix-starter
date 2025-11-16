defmodule AshPhoenixStarterWeb.Accounts.Users.UsersLiveTest do
  use AshPhoenixStarterWeb.ConnCase
  import Phoenix.LiveViewTest

  describe "Users live test" do
    test "List team users", %{conn: conn} do
      user = create_user()

      {:ok, users_live, html} =
        conn
        |> login(user)
        |> live(~p"/accounts/users")

      assert html =~ "Loading..."
      assert render_async(users_live) =~ to_string(user.email)
    end
  end
end
