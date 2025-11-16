defmodule AshPhoenixStarterWeb.Ledger.ChartOfAccountsLiveTest do
  use AshPhoenixStarterWeb.ConnCase

  defp create_accounts(tenant) do
    %{status: :success, records: records} =
      [
        %{identifier: "6100", name: "Matieres et fournitures", nature: "CHARGES", currency: :rwf},
        %{identifier: "7711", name: "Interets - Urgent Loan", nature: "PRODUITS", currency: :rwf}
      ]
      |> Ash.bulk_create(AshPhoenixStarter.Ledger.Account, :open,
        tenant: tenant,
        authorize?: false,
        return_records?: true
      )

    records
  end

  describe "Chart of Accounts" do
    test "It should list accounts in chart of accounts", %{conn: conn} do
      user = create_user()
      accounts = create_accounts(user.current_team)

      {:ok, view, html} =
        conn
        |> login(user)
        |> live(~p"/ledger/chart-of-accounts")

      # Confirm that all works as expected
      assert html =~ "Loading..."

      for account <- accounts do
        assert render_async(view) =~ to_string(account.identifier)
        assert render_async(view) =~ to_string(account.nature)
        assert render_async(view) =~ to_string(account.name)
      end
    end
  end
end
