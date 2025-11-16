defmodule AshPhoenixStarter.Farms.Farm do
  use Ash.Resource,
    domain: AshPhoenixStarter.Farms,
    data_layer: AshPostgres.DataLayer,
    fragments: [
      AshPhoenixStarter.Accounts.Fragments.GlobalPolicies,
      AshPhoenixStarter.Accounts.Fragments.Multitenancies
    ]

  postgres do
    table "farms"
    repo AshPhoenixStarter.Repo
  end

  attributes do
    uuid_v7_primary_key :id

    attribute :name, :string do
      allow_nil? false
      description "The name of the farm."
    end

    attribute :location, :string do
      allow_nil? false
      description "The geographical location of the farm."
    end

    attribute :total_area, :float do
      allow_nil? false
      description "The total area of the farm in acres or hectares."
    end

    timestamps()
  end

  relationships do
    has_many :fields, AshPhoenixStarter.Farms.Field
  end
end
