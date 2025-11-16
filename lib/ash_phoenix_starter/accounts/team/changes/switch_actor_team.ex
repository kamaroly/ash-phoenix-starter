defmodule AshPhoenixStarter.Accounts.Team.Changes.SwitchActorTeam do
  use Ash.Resource.Change

  def change(changeset, _team, _context) do
    Ash.Changeset.after_action(changeset, &set_owner_current_team/2)
  end

  # If the team was created without assigning the current owner,  then skip
  # auto setting of the team owner. It will be set manually later by
  # other means
  defp set_owner_current_team(_changeset, %{owner_user_id: nil} = team) do
    {:ok, team}
  end

  defp set_owner_current_team(_changeset, team) do
    opts = [authorize?: false]

    {:ok, _user} =
      AshPhoenixStarter.Accounts.User
      |> Ash.get!(team.owner_user_id, opts)
      |> Ash.Changeset.for_update(:set_current_team, %{team: team.domain})
      |> Ash.update(opts)

    {:ok, team}
  end
end
