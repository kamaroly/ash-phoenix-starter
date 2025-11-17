defmodule AshPhoenixStarter.Accounts do
  use Ash.Domain,
    otp_app: :AshPhoenixStarter

  resources do
    resource AshPhoenixStarter.Accounts.Token
    resource AshPhoenixStarter.Accounts.User
    resource AshPhoenixStarter.Accounts.Team
    resource AshPhoenixStarter.Accounts.UserTeam

    resource AshPhoenixStarter.Accounts.Group
    resource AshPhoenixStarter.Accounts.UserGroup
    resource AshPhoenixStarter.Accounts.GroupPermission

    resource AshPhoenixStarter.Accounts.UserImpersonation
  end
end
