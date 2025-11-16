defmodule AshPhoenixStarterWeb.Layouts do
  @moduledoc """
  This module holds layouts and related functionality
  used by your application.
  """
  use AshPhoenixStarterWeb, :html

  @doc """
  Renders your app layout.

  This function is typically invoked from every template,
  and it often contains your application menu, sidebar,
  or similar.

  ## Examples

      <Layouts.app flash={@flash}>
        <h1>Content</h1>
      </Layouts.app>

  """
  attr :flash, :map, required: true, doc: "the map of flash messages"

  attr :current_scope, :map,
    default: nil,
    doc: "the current [scope](https://hexdocs.pm/phoenix/scopes.html)"

  attr :current_user, AshPhoenixStarter.Accounts.User
  slot :inner_block, required: true
  attr :uri, URI, default: %URI{}

  def app(assigns) do
    ~H"""
    <div class="flex flex-col h-screen bg-gray-100">
      <!-- Top Navigation -->
      <.top_nav current_user={@current_user} />
      
    <!-- Main Content with Left Menu -->
      <div class="flex flex-1 overflow-hidden">
        <!-- Left Menu -->
        <aside
          class="w-64  shadow-md p-4 transform transition-all duration-300 ease-in-out md:relative md:translate-x-0"
          id="sidebar"
          x-data="{ open: false }"
          x-bind:class="{ 'translate-x-0': open, '-translate-x-full': !open }"
        >
          <button
            @click="open = !open"
            class="md:hidden absolute top-4 right-4 text-gray-600 hover:text-gray-900"
          >
            <svg
              class="h-6 w-6"
              fill="none"
              stroke="currentColor"
              viewBox="0 0 24 24"
              xmlns="http://www.w3.org/2000/svg"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M4 6h16M4 12h16m-7 6h7"
              >
              </path>
            </svg>
          </button>
          <nav>
            <.left_nav menu={AshPhoenixStarterWeb.Menu.left_menu()} uri={@uri} />
          </nav>
        </aside>
        
    <!-- Main Content -->
        <main class="flex-1 p-2 bg-white overflow-auto">
          <div class="card card-content">{render_slot(@inner_block)}</div>
          <.flash_group flash={@flash} />
        </main>
      </div>
    </div>
    """
  end

  def top_nav(assigns) do
    ~H"""
    <nav class="bg-white p-4 flex justify-between items-center border border-b border-gray-200 md:flex-row flex-col">
      <div
        class="text-xl font-semibold mb-2 md:mb-0 hover:cursor-pointer"
        phx-click={JS.navigate(~p"/")}
      >
        {app_name(@current_user)}
      </div>
      <.top_search_box />
      <div class="flex space-x-4">
        <span class="text-sm">{@current_user.email |> to_string() |> Phoenix.Naming.humanize()}</span>
        <.button variant="primary" phx-click={JS.navigate(~p"/sign-out")}>
          <.icon name="hero-arrow-right-start-on-rectangle-solid" />
        </.button>
      </div>
    </nav>
    """
  end

  attr :active, :boolean, default: false
  attr :href, :string, required: true
  attr :icon, :string, default: nil
  slot :inner_block

  def left_nav_link(assigns) do
    ~H"""
    <a
      href={@href}
      class={[
        "group -mx-2 -my-1 w-full inline-flex items-center gap-3 rounded-lg px-2 py-1 hover:text-primary hover:bg-base-100 hover:border hover:border-primary",
        @active && "w-full bg-primary text-primary-content"
      ]}
    >
      <.icon name={@icon} class="w-5 h-5" /> {render_slot(@inner_block)}
    </a>
    """
  end

  attr :uri, URI, default: %URI{path: "/"}
  attr :menu, :any, default: []

  def left_nav(assigns) do
    ~H"""
    <div :for={section <- @menu} class="mb-4">
      <h3 :if={section.title} class="text-md font-semibold text-primary/90 uppercase mb-2">
        {section.title}
      </h3>
      <ul class="space-y-2">
        <li :for={link <- section.links}>
          <.left_nav_link
            href={link.href}
            icon={link.icon}
            active={@uri.path == link.href}
          >
            {link.text}
          </.left_nav_link>
        </li>
      </ul>
    </div>
    """
  end

  defp top_search_box(assigns) do
    ~H"""
    <div class="relative w-[400px]">
      <div class="absolute left-4 top-1/2 -translate-y-1/2 text-gray-500 pointer-events-none">
        <.icon name="hero-magnifying-glass" class="w-6 h-6" />
      </div>
      <input
        type="search"
        class="w-full pl-12 pr-4 py-3 border border-gray-200 rounded-md bg-gray-50 text-base focus:outline-none focus:ring-1 focus:ring-gray-700 focus:border-gray-700 focus:bg-white placeholder-gray-500"
        placeholder="Search members, reports and more…"
      />
    </div>
    """
  end

  attr :flash, :map, required: true, doc: "the map of flash messages"
  attr :current_user, AshPhoenixStarter.Accounts.User, required: true
  slot :inner_block, required: true
  attr :uri, URI, default: %URI{}

  def merchants(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_user={@current_user} uri={@uri}>
      <h1 class="text-3xl font-bold mb-6">{gettext("New Merchant")}</h1>

      {render_slot(@inner_block)}
    </Layouts.app>
    """
  end

  attr :flash, :map, required: true, doc: "the map of flash messages"
  attr :current_user, AshPhoenixStarter.Accounts.User, required: true
  slot :inner_block, required: true
  attr :uri, URI, default: %URI{}

  def ussd(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_user={@current_user} uri={@uri}>
      <h1 class="text-3xl font-bold mb-6">{gettext("ussd")}</h1>

      {render_slot(@inner_block)}
    </Layouts.app>
    """
  end

  attr :flash, :map, required: true, doc: "the map of flash messages"
  attr :current_user, AshPhoenixStarter.Accounts.User, required: true
  slot :inner_block, required: true
  attr :uri, URI, default: %URI{}

  def account_users(assigns) do
    ~H"""
    <.app flash={@flash} current_user={@current_user} uri={@uri}>
      <h1 class="text-3xl font-bold mb-6">{gettext("Users")}</h1>
      <.button variant="primary" phx-click={JS.patch("/accounts/users/invite")}>
        {gettext("Invite User")}
      </.button>
      {render_slot(@inner_block)}
    </.app>
    """
  end

  attr :flash, :map, required: true, doc: "the map of flash messages"
  attr :current_user, AshPhoenixStarter.Accounts.User, required: true
  slot :inner_block, required: true
  attr :uri, URI, default: %URI{}

  def ledger(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_user={@current_user} uri={@uri}>
      <h1 class="text-3xl font-bold mb-6">{gettext("Ledger")}</h1>

      <.button variant="primary" phx-click={JS.patch(~p"/ledger/chart-of-accounts/new")}>
        <.icon name="hero-plus-solid" />
        {gettext("NeW Account")}
      </.button>
      {render_slot(@inner_block)}
    </Layouts.app>
    """
  end

  attr :flash, :map, required: true, doc: "the map of flash messages"
  attr :current_user, AshPhoenixStarter.Accounts.User, required: true
  slot :inner_block, required: true
  attr :uri, URI, default: %URI{}

  def account_groups(assigns) do
    ~H"""
    <.app flash={@flash} current_user={@current_user} uri={@uri}>
      <h1 class="text-3xl font-bold mb-6">{gettext("User Groups")}</h1>

      <.button variant="primary" phx-click={JS.patch("/accounts/groups/new")}>
        {gettext("New Group")}
      </.button>
      {render_slot(@inner_block)}
    </.app>
    """
  end

  attr :flash, :map, required: true, doc: "the map of flash messages"
  attr :current_user, AshPhoenixStarter.Accounts.User, required: true
  slot :inner_block, required: true
  attr :uri, URI, default: %URI{}

  def account_teams(assigns) do
    ~H"""
    <.app flash={@flash} current_user={@current_user} uri={@uri}>
      <.button variant="primary" phx-click={JS.patch("/accounts/teams/new")}>
        {gettext("New Team")}
      </.button>
      {render_slot(@inner_block)}
    </.app>
    """
  end

  @doc """
  Shows the flash group with standard titles and content.

  ## Examples

      <.flash_group flash={@flash} />
  """
  attr :flash, :map, required: true, doc: "the map of flash messages"
  attr :id, :string, default: "flash-group", doc: "the optional id of flash container"

  def flash_group(assigns) do
    ~H"""
    <div id={@id} aria-live="polite">
      <.flash kind={:info} flash={@flash} />
      <.flash kind={:error} flash={@flash} />

      <.flash
        id="client-error"
        kind={:error}
        title={gettext("We can't find the internet")}
        phx-disconnected={show(".phx-client-error #client-error") |> JS.remove_attribute("hidden")}
        phx-connected={hide("#client-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>

      <.flash
        id="server-error"
        kind={:error}
        title={gettext("Something went wrong!")}
        phx-disconnected={show(".phx-server-error #server-error") |> JS.remove_attribute("hidden")}
        phx-connected={hide("#server-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>
    </div>
    """
  end

  @doc """
  Provides dark vs light theme toggle based on themes defined in app.css.

  See <head> in root.html.heex which applies the theme before page load.
  """
  def theme_toggle(assigns) do
    ~H"""
    <div class="card relative flex flex-row items-center border-2 border-base-300 bg-base-300 rounded-full">
      <div class="absolute w-1/3 h-full rounded-full border-1 border-base-200 bg-base-100 brightness-200 left-0 [[data-theme=light]_&]:left-1/3 [[data-theme=dark]_&]:left-2/3 transition-[left]" />

      <button
        class="flex p-2 cursor-pointer w-1/3"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="system"
      >
        <.icon name="hero-computer-desktop-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>

      <button
        class="flex p-2 cursor-pointer w-1/3"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="light"
      >
        <.icon name="hero-sun-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>

      <button
        class="flex p-2 cursor-pointer w-1/3"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="dark"
      >
        <.icon name="hero-moon-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>
    </div>
    """
  end

  defp app_name(%{team: nil}), do: "Social Fund"
  defp app_name(%{team: %{name: name}}), do: Phoenix.Naming.humanize(name)
  # Embed all files in layouts/* within this module.
  # The default root.html.heex file contains the HTML
  # skeleton of your application, namely HTML headers
  # and other static content.
  embed_templates "layouts/*"
end
