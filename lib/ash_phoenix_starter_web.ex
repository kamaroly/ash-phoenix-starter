defmodule AshPhoenixStarterWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, components, channels, and so on.

  This can be used in your application as:

      use AshPhoenixStarterWeb, :controller
      use AshPhoenixStarterWeb, :html

  The definitions below will be executed for every controller,
  component, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define additional modules and import
  those modules here.
  """

  def static_paths, do: ~w(assets fonts images favicon.ico robots.txt)

  def router do
    quote do
      use Phoenix.Router, helpers: false

      # Import common connection and controller functions to use in pipelines
      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
    end
  end

  def controller do
    quote do
      use Phoenix.Controller, formats: [:html, :json]

      use Gettext, backend: AshPhoenixStarterWeb.Gettext

      import Plug.Conn

      unquote(verified_routes())
    end
  end

  def live_view do
    quote do
      use Phoenix.LiveView
      unquote(ash_form())
      unquote(html_helpers())
      unquote(live_replies())
      unquote(live_view_helpers())
    end
  end

  def live_component do
    quote do
      use Phoenix.LiveComponent
      unquote(ash_form())
      unquote(html_helpers())
      # Liveview helpers
      unquote(live_replies())
    end
  end

  defp ash_form do
    quote do
      use Phoenix.Component

      @impl Phoenix.LiveView
      def handle_event("validate", %{"form" => params}, socket) do
        {:noreply, assign(socket, :form, AshPhoenix.Form.validate(socket.assigns.form, params))}
      end

      def handle_event("save", %{"form" => params}, socket) do
        socket =
          case AshPhoenix.Form.submit(socket.assigns.form, params: params) do
            {:ok, _record} ->
              after_submit_url = get_after_submit_url(socket.assigns)

              socket
              |> put_flash(:info, "Saved!")
              |> redirect(to: "#{after_submit_url}")

            {:error, form} ->
              errors = AshPhoenix.Form.errors(form)
              assign(socket, :form, form)
          end

        {:noreply, socket}
      end

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

      def get_form(%{record_id: id, query_options: opts, resource: resource})
          when not is_nil(id) do
        require Ash.Query

        resource
        |> Ash.get!(id, opts)
        |> AshPhoenix.Form.for_update(:update, opts)
        |> to_form()
      end

      def get_form(%{resource: nil, query_options: opts, record: record} = assigns) do
        action_name = Map.get(assigns, :action_name, :update)

        record
        |> AshPhoenix.Form.for_update(action_name, opts)
        |> to_form()
      end

      def get_form(%{resource: resource, query_options: opts} = assigns) do
        action_name = Map.get(assigns, :action_name, :create)

        resource
        |> AshPhoenix.Form.for_create(action_name, opts)
        |> to_form()
      end

      def assign_attributes(socket) do
        socket
        |> assign(:attributes, get_attributes(socket.assigns.resource))
      end

      defp get_after_submit_url(%{after_submit_url: url}), do: url
      defp get_after_submit_url(%{uri: uri}), do: uri.path

      @doc """
      <AshPhoenixStarterWeb.CoreComponents.input
          :for={attribute <- @attributes}
          :if={attribute.writable?}
          type={get_field_type(attribute.type)}
          field={@form[attribute.name]}
          label={attribute.name}
        />
      """
      def get_attributes(resource), do: Ash.Resource.Info.attributes(resource)

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
  end

  def html do
    quote do
      use Phoenix.Component

      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [get_csrf_token: 0, view_module: 1, view_template: 1]

      # Include general helpers for rendering HTML
      unquote(html_helpers())
    end
  end

  defp html_helpers do
    quote do
      # Translation
      use Gettext, backend: AshPhoenixStarterWeb.Gettext

      # HTML escaping functionality
      import Phoenix.HTML
      # Core UI components
      import AshPhoenixStarterWeb.CoreComponents

      # Common modules used in templates
      alias Phoenix.LiveView.JS
      alias AshPhoenixStarterWeb.Layouts

      # Routes generation with the ~p sigil
      unquote(verified_routes())
    end
  end

  defp live_view_helpers do
    quote do
      @impl true
      def handle_params(_params, url, socket) do
        socket
        |> assign(:uri, URI.parse(url))
        |> noreply()
      end
    end
  end

  defp live_replies do
    quote do
      def ok(socket), do: {:ok, socket}
      def ok(socket, layout), do: {:ok, socket, layout}
      def cont(socket), do: {:cont, socket}
      def halt(socket), do: {:halt, socket}
      def noreply(socket), do: {:noreply, socket}
    end
  end

  def verified_routes do
    quote do
      use Phoenix.VerifiedRoutes,
        endpoint: AshPhoenixStarterWeb.Endpoint,
        router: AshPhoenixStarterWeb.Router,
        statics: AshPhoenixStarterWeb.static_paths()
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/live_view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
