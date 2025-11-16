defmodule AshPhoenixStarter.Accounts.Team.Changes.AddTeamOwner do
  use Ash.Resource.Change

  @impl Ash.Resource.Change
  def change(changeset, _opts, context) do
    Ash.Changeset.force_change_attribute(changeset, :owner_user_id, context.actor.id)
  end
end
