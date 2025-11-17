defmodule AshPhoenixStarter.Accounts.UserImpersonation do
  use Ash.Resource,
    otp_app: :AshPhoenixStarter,
    domain: AshPhoenixStarter.Accounts,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer]

  postgres do
    table "user_impersonations"
    repo AshPhoenixStarter.Repo
  end

  code_interface do
    define :start, action: :start_impersonation
    define :stop, action: :stop_impersonation
  end

  actions do
    default_accept [:ended_at, :status]
    defaults [:read, :update, :destroy]

    create :start_impersonation do
      argument :reason, :string do
        description "The reason for doing this impersonation"
      end

      accept [:reason, :impersonator_user_id, :impersonated_user_id]
      change atomic_update(:status, :active)
      change atomic_update(:started_at, DateTime.utc_now())
    end

    action :stop_impersonation, :map do
      argument :impersonator_user_id, :uuid do
        description "The ID of the impersonator. Since a user cannot impersonate
        two accounts at the same time, we don't have to filter the impersonated
        user"
      end

      run AshPhoenixStarter.Accounts.UserImpersonation.Actions.StopImpersonation
    end
  end

  attributes do
    uuid_v7_primary_key :id

    attribute :started_at, :utc_datetime_usec do
      writable? false
      default &DateTime.utc_now/0
      update_default &DateTime.utc_now/0
      description "Date and time when the impersonation session started."
    end

    attribute :ended_at, :datetime do
      allow_nil? true
      description "Date and time when the impersonation session ended (NULL if ongoing)."
    end

    attribute :reason, :string do
      allow_nil? true

      description "Optional text explaining the purpose of the impersonation (e.g., 'Troubleshooting login issue')."
    end

    attribute :status, :atom do
      allow_nil? false
      constraints one_of: [:active, :ended, :failed]
      default :active
      description "Current status of the impersonation (defaults to 'active')."
    end

    timestamps()
  end

  relationships do
    belongs_to :impersonator, AshPhoenixStarter.Accounts.User do
      source_attribute :impersonator_user_id
      description "The user who is performing the impersonation."
    end

    belongs_to :impersonated, AshPhoenixStarter.Accounts.User do
      source_attribute :impersonated_user_id
      description "The user who is being impersonated."
    end

    belongs_to :team, AshPhoenixStarter.Accounts.Team do
      source_attribute :team_domain
      description "The team of the user who is being impersonated"
    end
  end
end
