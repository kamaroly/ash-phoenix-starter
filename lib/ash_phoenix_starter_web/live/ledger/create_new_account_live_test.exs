defmodule AshPhoenixStarterWeb.Ledger.CreateNewAccountLiveTest do
  use AshPhoenixStarterWeb.ConnCase

  describe "Create new Ledger Account" do
    test "Create User Team", %{conn: conn} do
      user = create_user()

      {:ok, view, html} =
        conn
        |> login(user)
        |> live(~p"/ledger/chart-of-accounts/new")

      assert html =~
               user.email
               |> to_string()
               |> Phoenix.Naming.humanize()

      params = %{:identifier => 4000, :name => "Sales", :nature => "PRODUCTS", :currency => :usd}

      view
      |> form("#new-account-form", form: params)
      |> render_submit()

      # Confirm that the form was create
      require Ash.Query

      assert AshPhoenixStarter.Ledger.Account
             |> Ash.Query.filter(identifier == ^params.identifier)
             |> Ash.exists?(actor: user)
    end
  end
end
