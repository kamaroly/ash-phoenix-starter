defmodule AshPhoenixStarterWeb.Accounts.Groups.GroupsLive do
  use AshPhoenixStarterWeb, :live_view
  on_mount {AshPhoenixStarterWeb.LiveUserAuth, :live_user_required}

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <Layouts.account_groups current_user={@current_user} flash={@flash} uri={@uri}>
      <Cinder.Table.table
        resource={AshPhoenixStarter.Accounts.Group}
        actor={@current_user}
        row_click={fn group -> JS.navigate(~p"/accounts/groups/edit/#{group.id}") end}
      >
        <:col :let={group} field="name" label={gettext("Name")} search>{group.name}</:col>
        <:col :let={group} field="name" label={gettext("Description")} filter>
          {group.description}
        </:col>

        <:col :let={group}>
          <.button phx-click={JS.patch("/accounts/groups/permissions/#{group.id}")}>
            <.icon name="hero-shield-check" class="w-5 h-5" /> Permissions
          </.button>
        </:col>
      </Cinder.Table.table>
    </Layouts.account_groups>
    """
  end
end
