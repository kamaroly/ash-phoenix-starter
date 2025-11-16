defmodule AshPhoenixStarter.Accounts.User.Changes.AddToTeam do
  use Ash.Resource.Change

  @impl Ash.Resource.Change
  def change(changeset, _opts, context) do
    changeset
    |> Ash.Changeset.after_action(&add_user_current_team(&1, &2, context))
    |> Ash.Changeset.after_action(&add_user_to_team(&1, &2, context))
  end

  @impl Ash.Resource.Change
  def atomic(changeset, opts, context) do
    {:ok, change(changeset, opts, context)}
  end

  defp add_user_current_team(_changeset, user, context) do
    Ash.update(
      user,
      %{team: context.actor.current_team},
      action: :set_current_team,
      authorize?: false
    )
  end

  defp add_user_to_team(_changeset, user, context) do
    require Ash.Query

    actor_team =
      AshPhoenixStarter.Accounts.Team
      |> Ash.Query.filter(domain == ^context.actor.current_team)
      |> Ash.read_first!(Ash.Context.to_opts(context))

    {:ok, _user_team} =
      Ash.create(
        AshPhoenixStarter.Accounts.UserTeam,
        %{user_id: user.id, team_id: actor_team.id},
        Ash.Context.to_opts(context)
      )

    {:ok, user}
  end
end
