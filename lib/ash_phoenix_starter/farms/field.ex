defmodule AshPhoenixStarter.Farms.Field do
  use Ash.Resource,
    domain: AshPhoenixStarter.Farms,
    data_layer: AshPostgres.DataLayer,
    fragments: [
      AshPhoenixStarter.Accounts.Fragments.GlobalPolicies,
      AshPhoenixStarter.Accounts.Fragments.Multitenancies
    ]

  postgres do
    table "farm_fields"
    repo AshPhoenixStarter.Repo
  end

  attributes do
    uuid_v7_primary_key :id

    attribute :name, :string do
      allow_nil? false
      description "The name or identifier of the field."
    end

    attribute :area, :float do
      allow_nil? false
      description "The area of the field in acres or hectares."
    end

    attribute :soil_type, :string do
      allow_nil? false
      description "The type of soil in the field (e.g., loamy, sandy)."
    end

    attribute :location_coordinates, :string do
      description "The geographical coordinates of the field (e.g., latitude and longitude)."
    end

    timestamps()
  end

  relationships do
    belongs_to :farm, AshPhoenixStarter.Farms.Farm
  end
end
