defmodule AshPhoenixStarter.Farms.LaborAssignment do
  use Ash.Resource,
    domain: AshPhoenixStarter.Farms,
    data_layer: AshPostgres.DataLayer,
    fragments: [
      AshPhoenixStarter.Accounts.Fragments.GlobalPolicies,
      AshPhoenixStarter.Accounts.Fragments.Multitenancies
    ]

  postgres do
    table "farm_labor_assignments"
    repo AshPhoenixStarter.Repo
  end

  attributes do
    uuid_v7_primary_key :id

    attribute :assignment_date, :date do
      allow_nil? false
      description "The date of the labor assignment."
    end

    attribute :hours_worked, :float do
      allow_nil? false
      description "The number of hours worked in the assignment."
    end

    attribute :task_description, :string do
      allow_nil? true
      description "Description of the task performed."
    end

    attribute :cost, :decimal do
      allow_nil? true
      description "The cost associated with the labor assignment."
    end

    timestamps()
  end

  relationships do
    belongs_to :employee, AshPhoenixStarter.Farms.Employee, allow_nil?: false
    # Optional
    belongs_to :planting, AshPhoenixStarter.Farms.Planting, allow_nil?: true
    # Optional
    belongs_to :field, AshPhoenixStarter.Farms.Field, allow_nil?: true
  end
end
