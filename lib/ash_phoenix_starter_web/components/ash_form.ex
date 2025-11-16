defmodule AshPhoenixStarterWeb.AshForm do
  @moduledoc """
  A Phoenix LiveComponent for rendering forms based on Ash resources.

  This module provides a reusable form component that integrates with Ash and AshPhoenix
  to create or update records. It supports two modes:
  - **Auto-generated fields**: If no `inner_block` is provided, the form automatically
    generates input fields for all writable attributes of the specified Ash resource.
  - **Custom fields**: If an `inner_block` is provided, the form renders the custom content
    (e.g., manually defined input fields) instead of auto-generating fields.

  The form handles validation and submission, with optional redirection after a successful save.
  It supports Ash’s current_user-based authorization, multi-tenancy, and record loading for updates.

  ## Usage

  To use this component, you must provide an Ash resource and optionally other attributes
  like `tenant`, `current_user`, `record_id`, or `after_save_redirect_to`. The component can be
  used in two ways:

  ### 1. Auto-Generated Form
  If no `inner_block` is provided, the form generates input fields for all writable attributes
  of the specified resource.

  ```elixir
  <AshPhoenixStarterWeb.AshForm.form
    resource={AshPhoenixStarter.Members.Member}
    actor={@current_user}
    after_save_redirect_to={~p"/members"}
  />
  ```

  This will generate a form with input fields for all writable attributes of the
  `AshPhoenixStarter.Members.Member` resource, such as `name`, `email`, etc., based on the resource’s
  attribute definitions. The form submits to create or update a record and redirects to
  `/members` on success.

  ### 2. Custom Form Fields
  If an `inner_block` is provided, the form renders the custom content instead of
  auto-generating fields. Ensure that input names follow the `form[field_name]` format to
  align with AshPhoenix form handling.

  ```elixir
  <AshPhoenixStarterWeb.AshForm.form
    resource={AshPhoenixStarter.Members.Member}
    actor={@current_user}
    after_save_redirect_to={~p"/members"}
  >
    <:inner_block>
      <.input
        type="email"
        name="form[email]"
        id="form_email"
        class="w-full input"
      />
      <.input
        type="text"
        name="form[name]"
        id="form_name"
        class="w-full input"
      />
    </:inner_block>
  </AshPhoenixStarterWeb.AshForm.form>
  ```

  This renders a form with custom input fields for `email` and `name`, styled with the
  specified classes. The form still handles validation and submission using AshPhoenix.

  ## Attributes
  - `id`: A unique identifier for the component (default: auto-generated UUIDv7).
  - `resource`: The Ash resource (atom) defining the data structure (required).
  - `record`: A map representing the record to edit (default: `nil`).
  - `current_user`: A map representing the current current_user for authorization (default: `%{}`).
  - `tenant`: A string for multi-tenancy (default: `nil`).
  - `authorize?`: A boolean to enable/disable Ash authorization (default: `true`).
  - `record_id`: A string ID of the record to edit (default: `nil`).
  - `after_save_redirect_to`: A URL to redirect to after successful save (default: `nil`).
  - `inner_block`: A slot for custom form content (optional).

  ## Events
  - `validate`: Triggered on form input changes, validates the form using AshPhoenix.
  - `save`: Triggered on form submission, creates or updates the record using AshPhoenix.

  ## Dependencies
  - Ash
  - AshPhoenix
  - Phoenix.LiveComponent
  - AshPhoenixStarterWeb.CoreComponents (for input and button components)
  - Gettext (for internationalization)

  ## Notes
  - Ensure that the `resource` has properly defined attributes in its Ash configuration.
  - Custom input fields in the `inner_block` must use the `form[field_name]` naming convention
    to align with AshPhoenix form parameters.
  - The `get_field_type/1` function maps Ash types to HTML input types. Unmapped types default
    to `text` inputs.
  """

  use Gettext, backend: AshPhoenixStarterWeb.Gettext
  use Phoenix.LiveComponent

  alias AshPhoenix.Form

  # Define attributes and slot for the form component
  attr :id, :string, default: Ash.UUIDv7.generate()
  attr :resource, :atom, required: true
  attr :record, :map, default: nil
  attr :current_user, AshPhoenixStarter.Accounts.User, required: true
  attr :tenant, :string, default: nil
  attr :authorize?, :boolean, default: true
  attr :record_id, :string, default: nil
  attr :after_save_redirect_to, :string, default: nil
  slot :inner_block

  @doc """
  Renders a form component that delegates to the AshForm LiveComponent.

  This function passes all attributes and the `inner_block` to the LiveComponent for
  rendering. It’s the primary entry point for using this module in templates.

  ## Example
  ```elixir
  <AshPhoenixStarterWeb.AshForm.form
    resource={AshPhoenixStarter.Members.Member}
    actor={@current_user}
    after_save_redirect_to={~p"/members"}
  />
  ```
  """
  def form(assigns) do
    ~H"""
    <.live_component
      module={__MODULE__}
      current_user={@current_user}
      record={@record}
      tenant={@tenant}
      resource={@resource}
      record_id={@record_id}
      authorize?={@authorize?}
      after_save_redirect_to={@after_save_redirect_to}
      id={@id}
    >
      {render_slot(@inner_block)}
    </.live_component>
    """
  end

  @doc """
  Renders the form UI, either auto-generating fields or rendering the `inner_block`.

  If no `inner_block` is provided, it generates input fields for all writable attributes
  of the resource. Otherwise, it renders the custom content in the `inner_block`.
  """
  @impl true
  def render(assigns) do
    ~H"""
    <div class="m-4">
      <Phoenix.Component.form for={@form} phx-change="validate" phx-submit="save" phx-target={@myself}>
        <%!-- Render the inner block if provided --%>
        <div>
          {render_slot(@inner_block)}
        </div>

        <%!-- Auto-generate input fields if inner block is not provided --%>
        <div>
          <AshPhoenixStarterWeb.CoreComponents.input
            :for={attribute <- @attributes}
            :if={attribute.writable?}
            type={get_field_type(attribute.type)}
            field={@form[attribute.name]}
            label={gettext("%{label}", label: attribute.name)}
          />
        </div>

        <AshPhoenixStarterWeb.CoreComponents.button>
          Submit
        </AshPhoenixStarterWeb.CoreComponents.button>
      </Phoenix.Component.form>
    </div>
    """
  end

  @impl Phoenix.LiveComponent
  @doc """
  Initializes the component by assigning attributes, query options, and the form.
  """
  def update(assigns, socket) do
    socket
    |> assign(assigns)
    |> assign_query_opts()
    |> assign_attributes()
    |> assign_form()
    |> ok()
  end

  @impl Phoenix.LiveComponent
  @doc """
  Handles form validation on input changes.
  """
  def handle_event("validate", %{"form" => params}, socket) do
    form = Form.validate(socket.assigns.form, params)

    socket
    |> assign(:form, form)
    |> noreply()
  end

  @impl Phoenix.LiveComponent
  def handle_event("save", %{"form" => params}, socket) do
    case Form.submit(socket.assigns.form, params: params) do
      {:ok, _record} ->
        socket
        |> put_flash(:info, "Saved!")
        |> maybe_redirect()
        |> noreply()

      {:error, form} ->
        socket
        |> assign(:form, form)
        |> noreply()
    end
  end

  defp assign_query_opts(socket) do
    options = [
      actor: socket.assigns.current_user,
      tenant: socket.assigns.tenant,
      authorize?: socket.assigns.authorize?
    ]

    assign(socket, :query_options, options)
  end

  defp assign_form(socket) do
    if Map.has_key?(socket.assigns, :form) do
      socket
    else
      assign(socket, :form, get_form(socket.assigns))
    end
  end

  defp get_form(%{record_id: id, query_options: opts, resource: resource}) when not is_nil(id) do
    require Ash.Query

    resource
    |> Ash.get!(id, opts)
    |> Form.for_update(:update, opts)
    |> to_form()
  end

  defp get_form(%{resource: nil, query_options: opts, record: record}) do
    record
    |> Form.for_update(:update, opts)
    |> to_form()
  end

  defp get_form(%{resource: resource, query_options: opts}) do
    resource
    |> Form.for_create(:create, opts)
    |> to_form()
  end

  defp assign_attributes(socket) do
    assign(
      socket,
      :attributes,
      get_attributes(socket.assigns.resource)
    )
  end

  defp maybe_redirect(%{assigns: %{after_save_redirect_to: nil}} = socket) do
    socket
  end

  defp maybe_redirect(%{assigns: %{after_save_redirect_to: url}} = socket) do
    redirect(socket, to: url)
  end

  defp get_attributes(resource), do: Ash.Resource.Info.attributes(resource)

  defp get_field_type(Ash.Type.String), do: "text"
  defp get_field_type(Ash.Type.Date), do: "date"
  defp get_field_type(Ash.Type.Decimal), do: "number"
  defp get_field_type(Ash.Type.UtcDatetimeUsec), do: "datetime-local"
  defp get_field_type(Ash.Type.Integer), do: "number"
  defp get_field_type(Ash.Type.Boolean), do: "checkbox"
  defp get_field_type(Ash.Type.Float), do: "number"
  defp get_field_type(Ash.Type.CiString), do: "text"
  defp get_field_type(Ash.Type.Atom), do: "text"
  defp get_field_type(Ash.Type.UUID), do: "text"
  defp get_field_type(Ash.Type.UUIDv7), do: "text"
  defp get_field_type(_unknown), do: "text"

  defp ok(socket), do: {:ok, socket}
  defp noreply(socket), do: {:noreply, socket}

  # defp is_empty_slot?(slot) do
  #   assigns = %{}

  #   render_slot(slot).static
  #   |> Enum.map(&String.trim/1)
  #   |> Enum.reject(&(&1 in ["\n", ""]))
  #   |> Enum.empty?()
  # end
end
