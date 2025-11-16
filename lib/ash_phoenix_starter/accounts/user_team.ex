defmodule AshPhoenixStarter.Accounts.UserTeam do
  use Ash.Resource,
    domain: AshPhoenixStarter.Accounts,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "user_teams"
    repo AshPhoenixStarter.Repo
  end

  resource do
    # We don't need primary key for this resource
    require_primary_key? false
  end

  actions do
    default_accept [:user_id, :team_id]
    defaults [:create, :read, :update, :destroy]
  end

  attributes do
    uuid_v7_primary_key :id
    timestamps()
  end

  relationships do
    belongs_to :user, AshPhoenixStarter.Accounts.User do
      source_attribute :user_id
    end

    belongs_to :team, AshPhoenixStarter.Accounts.Team do
      source_attribute :team_id
    end
  end

  identities do
    identity :unique_user_team, [:user_id, :team_id]
  end
end
