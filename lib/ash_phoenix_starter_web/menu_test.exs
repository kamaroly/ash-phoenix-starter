defmodule AshPhoenixStarterWeb.MenuTest do
  use AshPhoenixStarterWeb.ConnCase

  describe "Menu module" do
    test "left_menu/0 module returns an array" do
      assert is_list(AshPhoenixStarterWeb.Menu.left_menu())
    end
  end
end
