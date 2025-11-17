defmodule AshPhoenixStarterWeb.Helpers do
  @doc """
  Confirms if a user is a among super users
  """
  @spec is_super_user?(AshPhoenixStarter.Accounts.User.t()) :: boolean()
  def is_super_user?(user) do
    super_users = Application.get_env(:AshPhoenixStarter, :super_users, [])
    to_string(user.email) in super_users
  end

  @doc """
  Confirm if the users is impersonative
  """
  def is_impersonated?(impersonator_user_id, impersonated_user_id) do
    require Ash.Query

    AshPhoenixStarter.Accounts.UserImpersonation
    |> Ash.Query.filter(impersonator_user_id == ^impersonator_user_id)
    |> Ash.Query.filter(impersonated_user_id == ^impersonated_user_id)
    |> Ash.exists?(authorize?: false)
  end
end
