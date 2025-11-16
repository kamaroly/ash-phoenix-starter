defmodule AshPhoenixStarterWeb.Accounts.Groups.GroupsLiveTest do
  use AshPhoenixStarterWeb.ConnCase

  describe "Groups Live" do
    test "Listing groups", %{conn: conn} do
      user = create_user()

      group_attrs = [
        %{name: "Group 1", description: "Group 1 Desc"},
        %{name: "Group 2", description: "Group 2 Desc"}
      ]

      groups =
        Ash.Seed.seed!(AshPhoenixStarter.Accounts.Group, group_attrs, tenant: user.current_team)

      {:ok, groups_live, html} =
        conn
        |> login(user)
        |> live(~p"/accounts/groups")

      assert html =~
               user.email
               |> to_string()
               |> Phoenix.Naming.humanize()

      assert html =~ "Loading..."

      for group <- groups, do: assert(render_async(groups_live) =~ to_string(group.name))
    end
  end
end
