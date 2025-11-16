defmodule AshPhoenixStarter.Accounts.GroupPermission.Changes.SyncPermissions do
  use Ash.Resource.ManualCreate

  @impl Ash.Resource.ManualCreate
  def create(changeset, _opts, context) do
    %Ash.BulkResult{status: :success} = delete_group_permissions(changeset, context)

    case create_group_permissions(changeset, context) do
      %Ash.BulkResult{status: :success, records: records} ->
        {:ok, List.last(records)}

      error ->
        {:error, error}
    end
  end

  defp delete_group_permissions(changeset, context) do
    require Ash.Query
    %{group_id: group_id} = List.first(changeset.arguments.permissions)

    AshPhoenixStarter.Accounts.GroupPermission
    |> Ash.Query.filter(group_id == ^group_id)
    |> Ash.bulk_destroy!(:destroy, %{}, Ash.Context.to_opts(context))
  end

  defp create_group_permissions(changeset, context) do
    Ash.bulk_create(
      changeset.arguments.permissions,
      AshPhoenixStarter.Accounts.GroupPermission,
      :create,
      tenant: context.tenant,
      actor: context.actor,
      authorize?: context.authorize?,
      return_records?: true
    )
  end
end
