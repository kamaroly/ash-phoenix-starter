defmodule AshPhoenixStarter.Farms.Crop do
  use Ash.Resource,
    domain: AshPhoenixStarter.Farms,
    data_layer: AshPostgres.DataLayer,
    fragments: [
      AshPhoenixStarter.Accounts.Fragments.GlobalPolicies,
      AshPhoenixStarter.Accounts.Fragments.Multitenancies
    ]

  postgres do
    table "farm_crops"
    repo AshPhoenixStarter.Repo
  end

  attributes do
    uuid_v7_primary_key :id

    attribute :name, :string do
      allow_nil? false
      description "The name of the crop."
    end

    attribute :type, :atom do
      allow_nil? false
      constraints one_of: [:grain, :vegetable]
      description "The type of the crop (e.g., grain, vegetable)."
    end

    attribute :planting_season, :string do
      allow_nil? false
      description "The season suitable for planting the crop."
    end

    attribute :growth_duration, :integer do
      allow_nil? false
      description "The duration in days for the crop to grow to harvest."
    end

    timestamps()
  end

  relationships do
    has_many :planting, AshPhoenixStarter.Farms.Planting
  end
end
