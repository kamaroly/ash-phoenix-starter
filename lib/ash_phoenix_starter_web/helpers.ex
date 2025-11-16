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
  def is_impersonated?(user) do
    Ash.Resource.get_metadata(user, :token)
    |> dbg()

    Ash.Resource.get_metadata(user, :impersonated?)
    |> dbg()
  end
end
