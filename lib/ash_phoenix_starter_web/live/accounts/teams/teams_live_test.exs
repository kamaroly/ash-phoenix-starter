defmodule AshPhoenixStarterWeb.Accounts.Teams.TeamsLiveTest do
  use AshPhoenixStarterWeb.ConnCase

  describe "Teams" do
    test "List team", %{conn: conn} do
      user = create_user()

      {:ok, view, html} =
        conn
        |> login(user)
        |> live(~p"/accounts/teams")

      assert html =~ "Loading..."
      assert render_async(view) =~ user.current_team
    end

    test "Switch team", %{conn: conn} do
      user = create_user()
      unique_id = String.replace(Ash.UUIDv7.generate(), "-", "_")
      params = %{name: "Team #{unique_id}", domain: "team_#{unique_id}"}

      {:ok, team_2} = Ash.create(AshPhoenixStarter.Accounts.Team, params, actor: user)

      {:ok, view, html} =
        conn
        |> login(user)
        |> live(~p"/accounts/teams")

      assert html =~ "Loading..."
      assert render_async(view) =~ team_2.name
      refute user.current_team == team_2.domain

      # Attempt to switch team, then confirm the user current team
      # matches the new team after switch
      assert render_click(view, "change-to-#{team_2.domain}", %{})

      require Ash.Query

      assert AshPhoenixStarter.Accounts.User
             |> Ash.Query.filter(current_team == ^team_2.domain)
             |> Ash.Query.filter(id == ^user.id)
             |> Ash.exists?(authorize?: false)
    end
  end
end
