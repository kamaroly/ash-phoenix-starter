defmodule AshPhoenixStarterWeb.Accounts.Users.UsersLive do
  use AshPhoenixStarterWeb, :live_view
  on_mount {AshPhoenixStarterWeb.LiveUserAuth, :live_user_required}

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <Layouts.account_users flash={@flash} current_user={@current_user} uri={@uri}>
      <Cinder.Table.table query={get_query(@current_user)}>
        <:col :let={user} field="email" search>{user.email}</:col>
        <:col :let={user} field="current_team">{Phoenix.Naming.humanize(user.current_team)}</:col>
        <:col :let={user}>
          <.button phx-click={JS.patch("/accounts/users/#{user.id}/groups")}>
            <.icon name="hero-shield-check" class="w-5 h-5" /> {gettext("Groups")}
          </.button>
        </:col>

        <:col :let={user} :if={AshPhoenixStarterWeb.Helpers.is_super_user?(@current_user)}>
          <.button
            phx-click={JS.patch("/accounts/users/impersonate/#{user.id}")}
            class="btn btn-warning text-warning-content"
          >
            <.icon name="hero-eye-slash" class="w-5 h-5" /> {gettext("Impersonate")}
          </.button>
        </:col>
      </Cinder.Table.table>
    </Layouts.account_users>
    """
  end

  defp get_query(current_user) do
    require Ash.Query

    Ash.Query.for_read(
      AshPhoenixStarter.Accounts.User,
      :admin_read,
      %{},
      authorize?: false,
      actor: current_user
    )
  end
end
