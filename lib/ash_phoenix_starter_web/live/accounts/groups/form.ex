defmodule AshPhoenixStarterWeb.Accounts.Groups.Form do
  use AshPhoenixStarterWeb, :html

  attr :form, :map, required: true

  def group_form(assigns) do
    ~H"""
    <.form for={@form} phx-change="validate" phx-submit="save" id="user-group-form">
      <.render_ash_form_errors form={@form} />

      <div class=" p-6 rounded-lg border border-gray-200">
        <h2 class="text-2xl font-semibold text-gray-700 mb-4">Member Identification</h2>
        <div class="">
          <.input
            field={@form[:name]}
            label={gettext("Group Name")}
            placeholder={gettext("E.g: Accountants")}
            required
          />
          <.input
            field={@form[:description]}
            label={gettext("Description")}
            type="textarea"
            aria-describedby="description"
          />
        </div>
      </div>

      <div class="flex justify-end mt-6">
        <.button>{gettext("Submit")}</.button>
      </div>
    </.form>
    """
  end
end
