defmodule AshPhoenixStarter.Accounts.Fragments.Multitenancies do
  use Spark.Dsl.Fragment, of: Ash.Resource

  preparations do
    prepare AshPhoenixStarter.Preparations.SetTenant
  end

  changes do
    change AshPhoenixStarter.Changes.SetTenant
  end

  multitenancy do
    strategy :context
  end
end
