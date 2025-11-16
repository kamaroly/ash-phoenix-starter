defmodule AshPhoenixStarterWeb.Accounts.Users.UserGroupsLiveTest do
  use AshPhoenixStarterWeb.ConnCase

  defp create_group(actor) do
    Ash.Seed.seed!(
      AshPhoenixStarter.Accounts.Group,
      %{name: "Group 1", description: "Test"},
      tenant: actor.current_team
    )
  end

  describe "User Groups test" do
    test "List user groups", %{conn: conn} do
      user = create_user()
      group = create_group(user)

      {:ok, user_groups_live, html} =
        conn
        |> login(user)
        |> live(~p"/accounts/groups")

      assert html =~ "Loading..."
      assert render_async(user_groups_live) =~ to_string(group.name)
    end
  end
end
