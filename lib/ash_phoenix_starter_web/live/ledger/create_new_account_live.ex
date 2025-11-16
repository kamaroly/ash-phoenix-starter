defmodule AshPhoenixStarterWeb.Ledger.CreateNewAccountLive do
  use AshPhoenixStarterWeb, :live_view

  on_mount {AshPhoenixStarterWeb.LiveUserAuth, :live_user_required}

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <Layouts.ledger flash={@flash} current_user={@current_user} uri={@uri}>
      <.form for={@form} phx-change="validate" phx-submit="save" id="new-account-form">
        <.render_ash_form_errors form={@form} />
        <.input field={@form[:identifier]} label={gettext("Code")} />
        <.input
          field={@form[:name]}
          label={gettext("Name")}
        />
        <.input field={@form[:currency]} label={gettext("Currency")} />
        <.input
          field={@form[:nature]}
          label={gettext("Nature")}
        />

        <.button variant="primary">{gettext("Submit")}</.button>
      </.form>
    </Layouts.ledger>
    """
  end

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    socket
    |> assign(:after_submit_url, ~p"/ledger/chart-of-accounts")
    |> assign(:resource, AshPhoenixStarter.Ledger.Account)
    |> assign(:action_name, :open)
    |> assign_query_opts()
    |> assign_attributes()
    |> assign_form()
    |> ok()
  end
end
