defmodule AshPhoenixStarterWeb.AshFormHelpers do
  @moduledoc """

  Your must implement update/2 in livecomponent or mount/3 in liveview
  @impl Phoenix.LiveComponent
  def update(assigns, socket) do
    socket
    |> assign(assigns)
    |> assign_query_opts()
    |> assign_attributes()
    |> assign_form()
    |> ok()
  end

  --------------------------------------------------
   <Phoenix.Component.form for={@form} phx-change="validate" phx-submit="save" phx-target={@myself}>
         <AshPhoenixStarterWeb.CoreComponents.input
            field={@form[attribute.name]}
            label={"Same input"}
          />
   </Phoenix.Component.form>

    AUTO GENERATE FORM BASED ON THE RESOURCE PROVIDED
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

        <AshPhoenixStarterWeb.CoreComponents.button>Submit</AshPhoenixStarterWeb.CoreComponents.button>
      </Phoenix.Component.form>

  """
  use Phoenix.LiveView

  def assign_query_opts(socket) do
    options = [actor: socket.assigns.current_user]

    assign(socket, :query_options, options)
  end

  def assign_form(socket) do
    if Map.has_key?(socket.assigns, :form) do
      socket
    else
      assign(socket, :form, get_form(socket.assigns))
    end
  end

  def get_form(%{record_id: id, query_options: opts, resource: resource}) when not is_nil(id) do
    require Ash.Query

    resource
    |> Ash.get!(id, opts)
    |> AshPhoenix.Form.for_update(:update, opts)
    |> to_form()
  end

  def get_form(%{resource: nil, query_options: opts, record: record}) do
    record
    |> AshPhoenix.Form.for_update(:update, opts)
    |> to_form()
  end

  def get_form(%{resource: resource, query_options: opts}) do
    resource
    |> AshPhoenix.Form.for_create(:create, opts)
    |> to_form()
  end

  def assign_attributes(socket) do
    assign(
      socket,
      :attributes,
      get_attributes(socket.assigns.resource)
    )
  end

  def maybe_redirect(%{assigns: %{after_save_redirect_to: nil}} = socket) do
    socket
  end

  def maybe_redirect(%{assigns: %{after_save_redirect_to: url}} = socket) do
    redirect(socket, to: url)
  end

  def get_attributes(resource), do: Ash.Resource.Info.attributes(resource)

  def render_attributes(assigns) do
    ~H"""
    <AshPhoenixStarterWeb.CoreComponents.input
      :for={attribute <- @attributes}
      :if={attribute.writable?}
      type={get_field_type(attribute.type)}
      field={@form[attribute.name]}
      label={attribute.name}
    />
    """
  end

  def get_field_type(Ash.Type.String), do: "text"
  def get_field_type(Ash.Type.Date), do: "date"
  def get_field_type(Ash.Type.Decimal), do: "number"
  def get_field_type(Ash.Type.UtcDatetimeUsec), do: "datetime-local"
  def get_field_type(Ash.Type.Integer), do: "number"
  def get_field_type(Ash.Type.Boolean), do: "checkbox"
  def get_field_type(Ash.Type.Float), do: "number"
  def get_field_type(Ash.Type.CiString), do: "text"
  def get_field_type(Ash.Type.Atom), do: "text"
  def get_field_type(Ash.Type.UUID), do: "text"
  def get_field_type(Ash.Type.UUIDv7), do: "text"
  def get_field_type(_unknown), do: "text"
end
