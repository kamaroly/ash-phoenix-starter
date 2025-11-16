defmodule AshPhoenixStarterWeb.PageController do
  use AshPhoenixStarterWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
