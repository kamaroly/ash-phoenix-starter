defmodule AshPhoenixStarter.Accounts.User.Relationships do
  use Spark.Dsl.Fragment, of: Ash.Resource

  relationships do
    belongs_to :team, AshPhoenixStarter.Accounts.Team do
      description "Current team object"
      source_attribute :current_team
      destination_attribute :domain
    end

    many_to_many :teams, AshPhoenixStarter.Accounts.Team do
      through AshPhoenixStarter.Accounts.UserTeam
      source_attribute_on_join_resource :user_id
      destination_attribute_on_join_resource :team_id
    end

    many_to_many :groups, AshPhoenixStarter.Accounts.Group do
      through AshPhoenixStarter.Accounts.UserGroup
      source_attribute_on_join_resource :user_id
      destination_attribute_on_join_resource :group_id
    end

    has_many :impersonations, AshPhoenixStarter.Accounts.UserImpersonation do
      destination_attribute :impersonated_user_id
      description "Active impersonation for this user"
    end
  end
end
