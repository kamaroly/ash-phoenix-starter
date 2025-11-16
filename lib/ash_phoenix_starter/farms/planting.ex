defmodule AshPhoenixStarter.Farms.Planting do
  use Ash.Resource,
    domain: AshPhoenixStarter.Farms,
    data_layer: AshPostgres.DataLayer,
    fragments: [
      AshPhoenixStarter.Accounts.Fragments.GlobalPolicies,
      AshPhoenixStarter.Accounts.Fragments.Multitenancies
    ]

  postgres do
    table "farm_plantings"
    repo AshPhoenixStarter.Repo
  end

  attributes do
    uuid_v7_primary_key :id

    attribute :planting_date, :date do
      allow_nil? false
      description "The date when the crop was planted."
    end

    attribute :expected_harvest_date, :date do
      allow_nil? false
      description "The expected date for harvesting the crop."
    end

    attribute :quantity_planted, :float do
      allow_nil? false
      description "The quantity of crop planted (e.g., in kg or number of plants)."
    end

    timestamps()
  end

  relationships do
    belongs_to :field, AshPhoenixStarter.Farms.Field
    belongs_to :crop, AshPhoenixStarter.Farms.Crop
    has_one :harvest, AshPhoenixStarter.Farms.Harvest
    # Assuming one-to-one for simplicity; can be has_many if partial harvests
    has_many :input_applications, AshPhoenixStarter.Farms.InputApplication
    has_many :labor_assignments, AshPhoenixStarter.Farms.LaborAssignment
  end
end
