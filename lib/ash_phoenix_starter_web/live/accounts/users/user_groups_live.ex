defmodule AshPhoenixStarterWeb.Accounts.Users.UserGroupsLive do
  use AshPhoenixStarterWeb, :live_view

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <Layouts.account_users flash={@flash} current_user={@current_user} uri={@uri}>
      <h1 class="text-2xl font-semibold text-gray-700 mb-4">
        {gettext("Assign Group Permissions")} {@user.email}
      </h1>

      <form phx-submit="save">
        <.select_all />

        <div
          :for={group <- @groups}
          class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-4"
        >
          <label class="flex items-center">
            <%!-- For non assigned permissions --%>
            <input
              :if={group_assigned?(@user.groups, group)}
              checked
              type="checkbox"
              name={"groups[#{group.id}]"}
              class="h-4 w-4 text-primary border-primary rounded focus:ring-primary mr-2"
            />

            <input
              :if={group_not_assigned?(@user.groups, group)}
              type="checkbox"
              name={"groups[#{group.id}]"}
              class="h-4 w-4 text-primary border-primary rounded focus:ring-primary mr-2"
            />
            <span class="text-sm text-gray-700">{Phoenix.Naming.humanize(group.name)}</span>
          </label>
        </div>

        <div class="flex justify-end mt-6">
          <.button>
            Save Permissions
          </.button>
        </div>
      </form>
    </Layouts.account_users>
    """
  end

  @impl Phoenix.LiveView
  def mount(params, _session, socket) do
    socket
    |> assign(:user_id, Map.get(params, "user_id", false))
    |> assign_user_groups()
    |> assign_groups()
    |> ok()
  end

  @impl Phoenix.LiveView
  def handle_event("save", %{"groups" => groups}, socket) do
    user_id = socket.assigns.user_id

    user_groups =
      groups
      |> Enum.filter(fn {_id, value} -> value == "on" end)
      |> Enum.map(fn {id, _value} -> %{group_id: id, user_id: user_id} end)

    case sync_user_groups(user_groups, socket) do
      {:ok, _perm} ->
        socket
        |> put_flash(:info, "Successfully updated groups")
        |> assign_user_groups()
        |> noreply()

      _errors ->
        socket
        |> put_flash(:error, "Failed updated groups")
        |> noreply()
    end
  end

  defp sync_user_groups(user_groups, socket) do
    %{current_user: current_user} = socket.assigns

    AshPhoenixStarter.Accounts.UserGroup
    |> Ash.Changeset.for_create(:sync, %{user_groups: user_groups})
    |> Ash.create(actor: current_user, tenant: current_user.current_team)
  end

  defp assign_groups(%{assigns: %{current_user: current_user}} = socket) do
    assign(socket, :groups, get_groups(current_user))
  end

  defp assign_user_groups(socket) do
    assign(socket, :user, get_user(socket.assigns))
  end

  defp get_user(%{current_user: current_user, user_id: user_id}) do
    Ash.get!(AshPhoenixStarter.Accounts.User, user_id,
      authorize?: false,
      load: :groups,
      tenant: current_user.current_team
    )
  end

  defp get_groups(current_user) do
    {:ok, groups} = Ash.read(AshPhoenixStarter.Accounts.Group, tenant: current_user.current_team)
    groups
  end

  defp group_assigned?(user_groups, group) do
    Enum.any?(user_groups, fn user_group -> user_group.id == group.id end)
  end

  defp group_not_assigned?(user_groups, group) do
    not group_assigned?(user_groups, group)
  end
end
