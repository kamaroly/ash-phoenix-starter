defmodule AshPhoenixStarter.Secrets do
  use AshAuthentication.Secret

  def secret_for(
        [:authentication, :tokens, :signing_secret],
        AshPhoenixStarter.Accounts.User,
        _opts,
        _context
      ) do
    Application.fetch_env(:AshPhoenixStarter, :token_signing_secret)
  end
end
