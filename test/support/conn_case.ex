defmodule AshPhoenixStarterWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use AshPhoenixStarterWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # The default endpoint for testing
      @endpoint AshPhoenixStarterWeb.Endpoint

      use AshPhoenixStarterWeb, :verified_routes

      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import Phoenix.LiveViewTest
      import AshPhoenixStarterWeb.ConnCase
    end
  end

  setup tags do
    AshPhoenixStarter.DataCase.setup_sandbox(tags)
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end

  def login(conn, user) do
    case AshAuthentication.Jwt.token_for_user(user, %{}, domain: AshPhoenixStarter.Accounts) do
      {:ok, token, _claims} ->
        conn
        |> Phoenix.ConnTest.init_test_session(%{})
        |> Plug.Conn.put_session(:user_token, token)

      {:error, reason} ->
        raise "Failed to generate token: #{inspect(reason)}"
    end
  end

  def get_user() do
    case Ash.read_first(AshPhoenixStarter.Accounts.User) do
      {:ok, nil} -> create_user()
      {:ok, user} -> user
    end
  end

  def create_user() do
    # Create a user and the person team automatically.
    # The person team will be the tenant for the query

    case Ash.read_first(AshPhoenixStarter.Accounts.User, authorize?: false) do
      {:ok, nil} ->
        user_params = %{
          email: "john.tester@example.com",
          password: "12345678",
          password_confirmation: "12345678"
        }

        Ash.create!(
          AshPhoenixStarter.Accounts.User,
          user_params,
          action: :register_with_password,
          authorize?: false
        )

      {:ok, user} ->
        user
    end
  end

  def get_group(user \\ nil) do
    actor = user || create_user()

    case Ash.read_first(AshPhoenixStarter.Accounts.Group, actor: actor) do
      {:ok, nil} -> create_groups(actor) |> Enum.at(0)
      {:ok, group} -> group
    end
  end

  def get_groups(user \\ nil) do
    actor = user || create_user()

    case Ash.read(AshPhoenixStarter.Accounts.Group, actor: actor) do
      {:ok, []} -> create_groups(actor)
      {:ok, groups} -> groups
    end
  end

  def create_groups(user \\ nil) do
    actor = user || create_user()

    group_attrs = [
      %{name: "Accountant", description: "Finance accountant"},
      %{name: "Manager", description: "Team manager"},
      %{name: "Developer", description: "Software developer"},
      %{name: "Admin", description: "System administrator"},
      %{name: "HR", description: "Human resources specialist"}
    ]

    Ash.Seed.seed!(AshPhoenixStarter.Accounts.Group, group_attrs, tenant: actor.current_team)
  end
end
