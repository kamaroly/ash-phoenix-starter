defmodule AshPhoenixStarter.Accounts.User.Validations.ValidateBelongsToTeam do
  use Ash.Resource.Validation

  @impl Ash.Resource.Validation
  def supports(_), do: [Ash.Query]

  @impl Ash.Resource.Validation
  def validate(subject, _opts, _context) do
    if user_belongs_to_team?(subject) do
      :ok
    else
      {:error, field: :current_team, message: "User must belong to the team"}
    end
  end

  @impl Ash.Resource.Validation
  def atomic(subject, opts, context) do
    validate(subject, opts, context)
  end

  defp user_belongs_to_team?(subject) do
    AshPhoenixStarter.Accounts.User
    |> Ash.Query.filter(teams.domain == ^subject.arguments.team)
    |> Ash.Query.filter(id == ^subject.data.id)
    |> Ash.exists?(authorize?: false)
  end
end
