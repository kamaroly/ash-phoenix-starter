defmodule AshPhoenixStarterWeb.Accounts.Groups.GroupPermissionsLiveTest do
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
        |> live(~p"/accounts/groups/permissions/#{group.id}")

      assert html =~ group.name

      params = %{
        "group" => %{"read" => "on", "update" => "on"},
        "user_team" => %{"read" => "on"}
      }

      user_groups_live
      |> form("#group-permissions", permissions: params)
      |> render_submit()

      # Confirm that permission was saved in the database
      require Ash.Query

      %{permissions: perms} =
        Ash.get!(
          AshPhoenixStarter.Accounts.Group,
          group.id,
          load: :permissions,
          actor: user
        )

      # Only selected permissions should be assigned to this group
      assert Enum.count(perms) == 3

      assert Enum.any?(perms, fn perm -> perm.action == "read" and perm.resource == "group" end)
      assert Enum.any?(perms, fn perm -> perm.action == "update" and perm.resource == "group" end)

      assert Enum.any?(perms, fn perm ->
               perm.action == "read" and perm.resource == "user_team"
             end)
    end
  end
end
