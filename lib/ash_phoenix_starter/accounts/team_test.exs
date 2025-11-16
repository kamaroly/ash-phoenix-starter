defmodule AshPhoenixStarter.Accounts.TeamTest do
  use AshPhoenixStarterWeb.ConnCase
  require Ash.Query

  describe "Team tests" do
    test "User team can be created" do
      user = create_user()

      # Create a new team for the user
      uuid = Ash.UUIDv7.generate()
      team_count = Ash.count!(AshPhoenixStarter.Accounts.Team) + 1
      team_attrs = %{name: "Team #{team_count} #{uuid}", domain: "team_#{team_count}_#{uuid}"}

      {:ok, team} = Ash.create(AshPhoenixStarter.Accounts.Team, team_attrs, actor: user)

      # New team should be stored successfully.
      assert AshPhoenixStarter.Accounts.Team
             |> Ash.Query.filter(domain == ^team.domain)
             |> Ash.Query.filter(owner_user_id == ^team.owner_user_id)
             |> Ash.exists?(authorize?: false)

      # New team should be set as the current team on the owner
      assert AshPhoenixStarter.Accounts.User
             |> Ash.Query.filter(id == ^user.id)
             |> Ash.Query.filter(current_team == ^team.domain)
             #  User resource has special policies for authorizations. We are skipping authorization by setting it to false
             |> Ash.exists?(authorize?: false)

      # New team should be added to the teams list of the owner
      assert AshPhoenixStarter.Accounts.User
             |> Ash.Query.filter(id == ^user.id)
             |> Ash.Query.filter(teams.id == ^team.id)
             |> Ash.exists?(authorize?: false)
    end
  end
end
