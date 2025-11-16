defmodule AshPhoenixStarter.Accounts.User.Validations.ValidateNewToTeam do
  use Ash.Resource.Validation

  @impl Ash.Resource.Validation
  def supports(_), do: [Ash.Query]

  @impl Ash.Resource.Validation
  def validate(changeset, _opts, context) do
    if Map.has_key?(changeset.attributes, :email) do
      if user_new_to_team?(changeset, context) do
        :ok
      else
        {:error, field: :email, message: "User exists"}
      end
    else
      {:error, field: :email, message: "Email field is required"}
    end
  end

  @impl Ash.Resource.Validation
  def atomic(changeset, opts, context), do: validate(changeset, opts, context)

  defp user_new_to_team?(changeset, context) do
    AshPhoenixStarter.Accounts.User
    |> Ash.Query.filter(email == ^changeset.attributes.email)
    |> Ash.Query.filter(teams.domain == ^context.actor.current_team)
    |> Ash.exists?(authorize?: false) == false
  end
end
