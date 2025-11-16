defmodule AshPhoenixStarter.Accounts.User.Actions.CreateUserIfNotExists do
  use Ash.Resource.ManualCreate

  @impl Ash.Resource.ManualCreate
  def create(changeset, _opts, _context) do
    case get_user(changeset) do
      {:ok, nil} -> {:ok, create_user!(changeset)}
      {:ok, user} -> {:ok, user}
    end
  end

  defp get_user(%{attributes: %{email: email}}) do
    require Ash.Query

    AshPhoenixStarter.Accounts.User
    |> Ash.Query.filter(email == ^to_string(email))
    |> Ash.read_first(authorize?: false)
  end

  defp create_user!(%{attributes: %{email: email}}) do
    Ash.Seed.seed!(AshPhoenixStarter.Accounts.User, %{email: to_string(email)})
  end
end
