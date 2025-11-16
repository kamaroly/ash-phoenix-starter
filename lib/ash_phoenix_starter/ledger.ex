defmodule AshPhoenixStarter.Ledger do
  use Ash.Domain,
    otp_app: :AshPhoenixStarter

  resources do
    resource AshPhoenixStarter.Ledger.Account
    resource AshPhoenixStarter.Ledger.Balance
    resource AshPhoenixStarter.Ledger.Transfer
  end
end
