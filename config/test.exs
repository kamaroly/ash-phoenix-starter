import Config
config :AshPhoenixStarter, token_signing_secret: "QLnUvgdau283stYcHZEjcJFGE4wcdS4Q"
config :bcrypt_elixir, log_rounds: 1
config :ash, policies: [show_policy_breakdowns?: true], disable_async?: true

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :AshPhoenixStarter, AshPhoenixStarter.Repo,
  username: "postgres",
  password: "ikijumba",
  hostname: "localhost",
  database: "AshPhoenixStarter_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :AshPhoenixStarter, AshPhoenixStarterWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "KMz7yLE75r8Osz2ab0HpoPizYiGNWHnX0TJAqzQ5qGcEVHMGumiS8h2oiMJnH2pG",
  server: false

# In test we don't send emails
config :AshPhoenixStarter, AshPhoenixStarter.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Enable helpful, but potentially expensive runtime checks
config :phoenix_live_view,
  enable_expensive_runtime_checks: true
