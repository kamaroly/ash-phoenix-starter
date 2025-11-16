defmodule AshPhoenixStarterWeb.CoreComponents.AshFormTest do
  use AshPhoenixStarterWeb.ConnCase

  describe "Ash Form" do
    test "Form can be rendered" do
      _assigns = %{
        id: Ash.UUIDv7.generate(),
        resource: AshPhoenixStarter.Members.Member,
        actor: %{},
        tenant: "test",
        authorize?: false
      }
    end
  end
end
