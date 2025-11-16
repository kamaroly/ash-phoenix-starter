defmodule AshPhoenixStarter.Farms do
  use Ash.Domain

  resources do
    resource AshPhoenixStarter.Farms.Farm
    resource AshPhoenixStarter.Farms.Field
    resource AshPhoenixStarter.Farms.Crop
    resource AshPhoenixStarter.Farms.Employee
    resource AshPhoenixStarter.Farms.Harvest
    resource AshPhoenixStarter.Farms.Planting
    resource AshPhoenixStarter.Farms.InputType
    resource AshPhoenixStarter.Farms.LaborAssignment
    resource AshPhoenixStarter.Farms.InputApplication
  end
end
