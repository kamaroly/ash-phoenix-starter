defmodule AshPhoenixStarterWeb.Ledger.TransfersLive do
  use AshPhoenixStarterWeb, :live_view

  on_mount {AshPhoenixStarterWeb.LiveUserAuth, :live_user_required}
  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <Layouts.ledger flash={@flash} current_user={@current_user} uri={@uri}>
      <Cinder.Table.table
        resource={AshPhoenixStarter.Ledger.Transfer}
        actor={@current_user}
        query_opts={[load: [from_account: :to_account]]}
      >
        <:col :let={transfer} label={gettext("Date")}>
          {transfer.timestamp |> DateTime.to_string()}
        </:col>
        <:col :let={transfer} label={gettext("Transfer ID")}>{transfer.id}</:col>
        <:col :let={transfer} field="from_account.name" label="From Account" filter>
          {transfer.from_account.identifier} - {transfer.from_account.name}
        </:col>
        <:col :let={transfer} field="to_account.name" label="To Account" filter>
          {transfer.to_account.identifier} - {transfer.to_account.name}
        </:col>
        <:col :let={transfer} label="Amount">
          {Money.new(transfer.amount, transfer.to_account.currency)}
        </:col>
      </Cinder.Table.table>
    </Layouts.ledger>
    """
  end
end
