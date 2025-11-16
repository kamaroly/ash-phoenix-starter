defmodule AshPhoenixStarterWeb.Accounts.Users.InviteUserLive do
  use AshPhoenixStarterWeb, :live_view

  def render(assigns) do
    ~H"""
    <Layouts.account_users flash={@flash} current_user={@current_user} uri={@uri}>
      <.form for={@form} phx-change="validate" phx-submit="save" id="user-group-form">
        <.render_ash_form_errors form={@form} />

        <div class=" p-6 rounded-lg border border-gray-200">
          <h2 class="text-2xl font-semibold text-gray-700 mb-4">Member Identification</h2>
          <div class="">
            <.input
              field={@form[:email]}
              label={gettext("User Email")}
              placeholder={gettext("E.g: john@example.com")}
              required
            />
          </div>
        </div>

        <div class="flex justify-end mt-6">
          <.button variant="primary">{gettext("Submit")}</.button>
        </div>
      </.form>
    </Layouts.account_users>
    """
  end

  def mount(_params, _session, socket) do
    socket
    |> assign_invite_form()
    |> ok()
  end

  defp assign_invite_form(socket) do
    form =
      AshPhoenixStarter.Accounts.User
      |> AshPhoenix.Form.for_create(:invite,
        actor: socket.assigns.current_user,
        authorize?: false
      )
      |> to_form()

    assign(socket, :form, form)
  end
end
