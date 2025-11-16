defmodule AshPhoenixStarterWeb.HelpersTest do
  use ExUnit.Case, async: true

  alias AshPhoenixStarter.Accounts.User

  @moduledoc """
  Tests for user-related functions in the Accounts context.
  """

  describe "is_super_user?/1" do
    setup do
      # Temporarily set the super_users config for testing
      original_super_users = Application.get_env(:AshPhoenixStarter, :super_users, [])
      Application.put_env(:AshPhoenixStarter, :super_users, ["super@example.com"])

      on_exit(fn ->
        Application.put_env(:AshPhoenixStarter, :super_users, original_super_users)
      end)
    end

    test "returns true if the user's email is in the super_users config" do
      user = %User{email: "super@example.com"}
      assert AshPhoenixStarterWeb.Helpers.is_super_user?(user)
    end

    test "returns false if the user's email is not in the super_users config" do
      user = %User{email: "regular@example.com"}
      refute AshPhoenixStarterWeb.Helpers.is_super_user?(user)
    end

    test "handles nil email gracefully" do
      user = %User{email: nil}
      refute AshPhoenixStarterWeb.Helpers.is_super_user?(user)
    end
  end
end
