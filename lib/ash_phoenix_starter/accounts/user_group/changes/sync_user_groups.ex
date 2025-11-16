defmodule AshPhoenixStarter.Accounts.UserGroup.Changes.SyncUserGroups do
  use Ash.Resource.ManualCreate

  @impl Ash.Resource.ManualCreate
  def create(changeset, _opts, context) do
    %Ash.BulkResult{status: :success} = delete_user_groups(changeset, context)

    case create_user_groups(changeset, context) do
      %Ash.BulkResult{status: :success, records: records} ->
        {:ok, List.last(records)}

      error ->
        {:error, error}
    end
  end

  defp delete_user_groups(changeset, context) do
    require Ash.Query

    %{user_id: user_id} = List.first(changeset.arguments.user_groups)

    AshPhoenixStarter.Accounts.UserGroup
    |> Ash.Query.filter(user_id == ^user_id)
    |> Ash.bulk_destroy!(:destroy, %{}, Ash.Context.to_opts(context))
  end

  defp create_user_groups(changeset, context) do
    Ash.bulk_create(
      changeset.arguments.user_groups,
      AshPhoenixStarter.Accounts.UserGroup,
      :create,
      tenant: context.tenant,
      actor: context.actor,
      authorize?: context.authorize?,
      return_records?: true
    )
  end
end
