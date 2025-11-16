defmodule AshPhoenixStarterWeb.Ussd.UssdsLive do
  use AshPhoenixStarterWeb, :live_view

  on_mount {AshPhoenixStarterWeb.LiveUserAuth, :live_user_required}

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <Layouts.ussd flash={@flash} current_user={@current_user} uri={@uri}>
      <ul class="menu bg-base-200 rounded-box w-56">
        <li><a>Welcome to AshPhoenixStarter</a></li>
        <li>
          <details closed>
            <summary>1. Registration</summary>
            <ul>
              <li><a>1. Agent</a></li>
              <li><a>2. Merchant</a></li>
            </ul>
          </details>
        </li>
        <li>
          <details closed>
            <summary>2. Check Balance</summary>
            <ul>
              <li><a>1. My Balance</a></li>
              <li><a>2. Agent Balance</a></li>
              <li>
                <details closed>
                  <summary>1. My Balance</summary>
                  <ul>
                    <li><a>1. Airtime</a></li>
                    <li><a>2. Mobile Money</a></li>
                  </ul>
                </details>
              </li>
            </ul>
          </details>
        </li>
      </ul>
    </Layouts.ussd>
    """
  end
end
