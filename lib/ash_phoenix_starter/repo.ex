defmodule AshPhoenixStarter.Repo do
  use AshPostgres.Repo,
    otp_app: :AshPhoenixStarter

  @impl AshPostgres.Repo
  def installed_extensions do
    # Add extensions here, and the migration generator will install them.
    [
      "ash-functions",
      "uuid-ossp",
      "citext",
      "pg_trgm",
      AshMoney.AshPostgresExtension
    ]
  end

  # Don't open unnecessary transactions
  # will default to `false` in 4.0
  @impl AshPostgres.Repo
  def prefer_transaction? do
    false
  end

  @impl AshPostgres.Repo
  def min_pg_version do
    %Version{major: 16, minor: 0, patch: 0}
  end

  @doc """
  Used by migrations --tenants to list all tenants,
  create related schemas and migrates
  """
  @impl AshPostgres.Repo
  def all_tenants do
    AshPhoenixStarter.Accounts.Team
    |> Ash.read!()
    |> Enum.map(& &1.domain)
  end
end
