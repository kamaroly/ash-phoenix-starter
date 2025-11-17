defmodule AshPhoenixStarter.Accounts.User.Attributes do
  use Spark.Dsl.Fragment, of: Ash.Resource

  attributes do
    uuid_primary_key :id

    attribute :email, :ci_string do
      allow_nil? false
      public? true
    end

    attribute :hashed_password, :string do
      sensitive? true
    end

    attribute :confirmed_at, :utc_datetime_usec

    attribute :current_team, :string do
      description "Current team of the user"
      allow_nil? true
    end

    timestamps()
  end

  identities do
    identity :unique_email, [:email]
  end
end
