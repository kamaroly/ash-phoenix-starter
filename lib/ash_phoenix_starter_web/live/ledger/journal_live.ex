defmodule AshPhoenixStarterWeb.Ledger.JournalLive do
  use AshPhoenixStarterWeb, :live_view

  on_mount {AshPhoenixStarterWeb.LiveUserAuth, :live_user_required}
  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <Layouts.ledger flash={@flash} current_user={@current_user} uri={@uri}>
      <Cinder.Table.table
        resource={AshPhoenixStarter.Ledger.Account}
        actor={@current_user}
        query_opts={[load: [balances: :transfer]]}
      >
        <:col :let={account} field="identifier" label="Account" filter>
          {account.identifier} - {account.name} ({account.currency})
        </:col>
        <:col :let={account} label="Transfers">
          <div class="overflow-x-auto">
            <table class="table table-zebra table-compact w-full">
              <thead>
                <tr>
                  <th>Date</th>
                  <th>Transfer ID</th>
                  <th>Debit ({account.currency})</th>
                  <th>Credit ({account.currency})</th>
                  <th>Balance ({account.currency})</th>
                </tr>
              </thead>
              <tbody>
                <tr :for={balance <- account.balances}>
                  <td>{balance.transfer.timestamp |> DateTime.to_string()}</td>
                  <td>{balance.transfer_id}</td>
                  <td>
                    {if account.id == balance.transfer.from_account_id,
                      do: balance.transfer.amount.amount,
                      else: ""}
                  </td>
                  <td>
                    {if account.id == balance.transfer.to_account_id,
                      do: balance.transfer.amount.amount,
                      else: ""}
                  </td>
                  <td>{balance.balance.amount}</td>
                </tr>
              </tbody>
            </table>
          </div>
        </:col>
      </Cinder.Table.table>
    </Layouts.ledger>
    """
  end
end
