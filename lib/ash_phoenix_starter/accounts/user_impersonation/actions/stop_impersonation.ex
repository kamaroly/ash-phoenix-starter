defmodule AshPhoenixStarter.Accounts.UserImpersonation.Actions.StopImpersonation do
  use Ash.Resource.Actions.Implementation
  require Ash.Query

  @impl Ash.Resource.Actions.Implementation
  def run(inputs, _opts, _context) do
    %Ash.BulkResult{status: :success, records: records} =
      AshPhoenixStarter.Accounts.UserImpersonation
      |> Ash.Query.filter(:impersonator_user_id == ^inputs.arguments.impersonator_user_id)
      |> Ash.bulk_update(
        :update,
        _params = %{status: :ended, ended_at: DateTime.utc_now()},
        authorize?: false
      )

    {:ok, :ok}
  end
end
