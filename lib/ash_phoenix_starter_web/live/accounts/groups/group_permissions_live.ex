defmodule AshPhoenixStarterWeb.Accounts.Groups.GroupPermissionsLive do
  use AshPhoenixStarterWeb, :live_view

  on_mount {AshPhoenixStarterWeb.LiveUserAuth, :live_user_required}

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <Layouts.account_groups current_user={@current_user} flash={@flash} uri={@uri}>
      
    <!-- SELECT ALL -->

      <h2 class="text-2xl font-semibold text-gray-700 mb-4">
        Manage Permission for {Phoenix.Naming.humanize(@group.name)}
      </h2>
      <.form for={@form} phx-submit="save" id="group-permissions">
        <.select_all />
        <div class="mb-6">
          <div class="space-y-6">
            <!-- Resource: Users -->
            <div :for={resource <- @resources} class="border border-gray-300 rounded-md p-4">
              <h4 class="text-lg font-medium text-gray-600 mb-3">
                {Phoenix.Naming.humanize(resource.short_name)}
              </h4>
              <div
                :for={action <- resource.actions}
                class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-4"
              >
                <label class="flex items-center">
                  <%!-- For already assigned permissions --%>
                  <input
                    :if={action.assigned?}
                    checked
                    type="checkbox"
                    id={"#{resource.short_name}-#{action.name}"}
                    name={"permissions[#{resource.short_name}][#{action.name}]"}
                    class="h-4 w-4 text-primary border-primary rounded focus:ring-primary mr-2"
                  />

                  <%!-- For non assigned permissions --%>
                  <input
                    :if={action.assigned? == false}
                    type="checkbox"
                    id={"#{resource.short_name}-#{action.name}"}
                    name={"permissions[#{resource.short_name}][#{action.name}]"}
                    class="h-4 w-4 text-primary border-primary rounded focus:ring-primary mr-2"
                  />
                  <span class="text-sm text-gray-700">
                    {Phoenix.Naming.humanize(action.name)}
                    <i :if={action.description}>: {Phoenix.Naming.humanize(action.description)}</i>
                  </span>
                </label>
              </div>
            </div>
          </div>
        </div>
        <div class="flex justify-end mt-6">
          <.button>
            Save Permissions
          </.button>
        </div>
      </.form>
    </Layouts.account_groups>
    """
  end

  @impl Phoenix.LiveView
  def mount(params, _session, socket) do
    socket
    |> assign(:group_id, Map.get(params, "group_id", false))
    |> assign_group_permission_form()
    |> assign_group_permissions()
    |> assign_resource_actions()
    |> assign_group()
    |> ok()
  end

  @impl Phoenix.LiveView
  def handle_event("save", %{"permissions" => permissions}, socket) do
    case sync_permissions(permissions, socket) do
      {:ok, _perm} ->
        socket
        |> put_flash(:info, "Successfully updated permissions")
        |> noreply()

      _errors ->
        socket
        |> put_flash(:error, "Failed updated permissions")
        |> noreply()
    end
  end

  defp assign_group_permissions(socket) do
    require Ash.Query

    group_permissions =
      AshPhoenixStarter.Accounts.GroupPermission
      |> Ash.Query.filter(group_id == ^socket.assigns.group_id)
      |> Ash.read!(actor: socket.assigns.current_user)

    assign(socket, :group_permissions, group_permissions)
  end

  defp assign_resource_actions(socket), do: assign(socket, :resources, get_resources(socket))

  defp assign_group(socket) do
    group =
      Ash.get!(
        AshPhoenixStarter.Accounts.Group,
        socket.assigns.group_id,
        actor: socket.assigns.current_user
      )

    assign(socket, :group, group)
  end

  defp sync_permissions(permissions, socket) do
    group_id = socket.assigns.group_id
    current_user = socket.assigns.current_user

    permission_attributes =
      for {resource, perms} <- permissions, {action, "on"} <- perms do
        %{resource: resource, action: action, group_id: group_id}
      end

    AshPhoenixStarter.Accounts.GroupPermission
    |> Ash.Changeset.for_create(:sync, %{permissions: permission_attributes})
    |> Ash.create(actor: current_user, tenant: current_user.current_team)
  end

  defp assign_group_permission_form(socket) do
    form =
      AshPhoenix.Form.for_create(
        AshPhoenixStarter.Accounts.GroupPermission,
        :create,
        actor: socket.assigns.current_user
      )
      |> to_form()

    assign(socket, :form, form)
  end

  defp get_resources(socket) do
    # Fetch group permissions from the socket assigns
    group_permissions = socket.assigns.group_permissions

    # Iterate over all configured Ash domains
    for domain <- Application.get_env(:AshPhoenixStarter, :ash_domains) do
      # For each domain, process its resources
      for resource <- Ash.Domain.Info.resources(domain) do
        # Get the short name of the resource
        resource_name = Ash.Resource.Info.short_name(resource)

        %{
          short_name: resource_name,
          actions: build_actions(resource, resource_name, group_permissions)
        }
      end
    end
    |> Enum.flat_map(& &1)
  end

  # Helper function to build the list of actions for a resource
  defp build_actions(resource, resource_name, group_permissions) do
    for action <- Ash.Resource.Info.actions(resource) do
      %{
        type: action.type,
        name: action.name,
        description: action.description,
        assigned?: action_assigned?(action, resource_name, group_permissions)
      }
    end
  end

  # Helper function to check if an action is assigned for the resource
  defp action_assigned?(action, resource_name, group_permissions) do
    Enum.any?(group_permissions, fn gp ->
      gp.action == Atom.to_string(action.name) &&
        gp.resource == Atom.to_string(resource_name)
    end)
  end
end
