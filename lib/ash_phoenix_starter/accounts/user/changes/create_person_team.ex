defmodule AshPhoenixStarter.Accounts.User.Changes.CreatePersonTeam do
  use Ash.Resource.Change

  def change(changeset, _opts, _context) do
    # Only create team automatically for specific actions
    if changeset.action.name in [:register_with_password] do
      Ash.Changeset.after_action(changeset, &create_personal_team/2)
    else
      changeset
    end
  end

  def atomic(changeset, opts, context) do
    {:ok, change(changeset, opts, context)}
  end

  defp create_personal_team(_changeset, user) do
    team_count = Ash.count!(AshPhoenixStarter.Accounts.Team) + 1
    team_attrs = %{name: "Personal Team", domain: "personal_team_#{team_count}"}

    {:ok, _team} = Ash.create(AshPhoenixStarter.Accounts.Team, team_attrs, actor: user)
    {:ok, Map.put(user, :current_team, team_attrs.domain)}
  end
end
