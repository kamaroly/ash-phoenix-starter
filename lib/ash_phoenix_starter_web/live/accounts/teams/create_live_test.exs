defmodule AshPhoenixStarterWeb.Accounts.Teams.CreateLiveTest do
  use AshPhoenixStarterWeb.ConnCase

  describe "User Teams" do
    test "Create User Team", %{conn: conn} do
      user = create_user()

      {:ok, view, html} =
        conn
        |> login(user)
        |> live(~p"/accounts/teams/new")

      assert html =~
               user.email
               |> to_string()
               |> Phoenix.Naming.humanize()

      # Attempt to create the group

      params = %{name: "Company 1", domain: "company_1"}

      view
      |> form("#user-teams-form", form: params)
      |> render_submit()

      # Confirm that the form was create
      require Ash.Query

      assert AshPhoenixStarter.Accounts.Team
             |> Ash.Query.filter(name == ^params.name)
             |> Ash.Query.filter(users.id == ^user.id)
             |> Ash.Query.filter(domain == ^params.domain)
             |> Ash.exists?(actor: user)
    end
  end
end
