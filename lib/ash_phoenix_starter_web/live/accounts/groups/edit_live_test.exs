defmodule AshPhoenixStarterWeb.Accounts.Groups.EditLiveTest do
  use AshPhoenixStarterWeb.ConnCase

  defp create_group(actor) do
    Ash.Seed.seed!(
      AshPhoenixStarter.Accounts.Group,
      %{name: "Group 1", description: "Test"},
      tenant: actor.current_team
    )
  end

  describe "Edit Group" do
    test "Group can be edited", %{conn: conn} do
      user = create_user()
      group = create_group(user)

      {:ok, view, _html} =
        conn
        |> login(user)
        |> live(~p"/accounts/groups/edit/#{group.id}")

      # Attempt to create the group
      params = %{name: "Updated Group 2", description: "Description Updated 2"}

      view
      |> form("#user-group-form", form: params)
      |> render_submit()

      # Confirm that the form was create
      require Ash.Query

      assert AshPhoenixStarter.Accounts.Group
             |> Ash.Query.filter(id == ^group.id)
             |> Ash.Query.filter(name == ^params.name)
             |> Ash.Query.filter(description == ^params.description)
             |> Ash.exists?(actor: user)
    end
  end
end
