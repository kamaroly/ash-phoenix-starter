defmodule AshPhoenixStarterWeb.DashboardLive do
  use AshPhoenixStarterWeb, :live_view
  on_mount {AshPhoenixStarterWeb.LiveUserAuth, :live_user_required}

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_user={@current_user} uri={@uri}>
      <h1 class="text-3xl font-bold mb-6">Today's Overview</h1>
      <!-- Stats Section -->
      <div class="grid grid-cols-1 md:grid-cols-4 gap-6 mb-6">
        <div class="bg-base-100 border border-lg border-primary rounded-box p-6">
          <div class="stat-figure"></div>
          <div class="stat-title text-lg">Total Fields</div>
          <div class="stat-value">200</div>
          <div class="stat-desc">Active fields</div>
        </div>

        <div class=" bg-base-100 bg-primary text-primary-content rounded-box p-6">
          <div class="stat-figure"></div>
          <div class="stat-title text-lg text-base-200">Harvest Today</div>
          <div class="stat-value">32,000,299</div>
          <div class="stat-desc text-base-100">Total havests</div>
        </div>

        <div class=" bg-base-100 bg-primary-content text-primary border border-primary rounded-box p-6">
          <div class="stat-title text-primary text-lg">Pending Harvest</div>
          <div class="stat-value ">12,000</div>
          <div class="stat-desc text-primary">Next Harvest</div>
        </div>

        <div class="stat bg-base-100 border border-secondary rounded-box p-6">
          <div class="stat-figure "></div>
          <div class="stat-title text-lg">Transactions Today</div>
          <div class="stat-value">7,382,952</div>
          <div class="stat-desc">Number of transactions processed</div>
        </div>
      </div>

      <div class="grid grid-cols-2 gap-2">
        <!-- Map Section -->
        <div class="card border border-primary">
          <div class="card-body">
            <h2 class="card-title">Merchant Locations Map</h2>
            <AshPhoenixStarterWeb.Map.map />
          </div>
        </div>
        
    <!-- Low Stock Section -->
        <div class="card bg-base-100 border border-primary ">
          <div class="card-body">
            <h2 class="card-title">Actual vs Predicted Sales (Today)</h2>
            <AshPhoenixStarterWeb.Chart.chart />
          </div>
          <div class="divider" />
          <div class="card-body">
            <h2 class="card-title">Merchants About to Run Out of Stock</h2>
            <div class="overflow-x-auto">
              <table class="table">
                <thead>
                  <tr>
                    <th>Merchant Name</th>
                    <th>Product</th>
                    <th>Remaining Stock</th>
                    <th>Alert Level</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td>Merchant A</td>
                    <td>Product X</td>
                    <td>{Money.new(7200, :xof)}</td>
                    <td><span class="badge badge-warning">Low</span></td>
                  </tr>
                  <tr>
                    <td>Merchant B</td>
                    <td>Product Y</td>
                    <td>{Money.new(7200, :xof)}</td>
                    <td><span class="badge badge-error">Critical</span></td>
                  </tr>
                  <tr>
                    <td>Merchant C</td>
                    <td>Product Z</td>
                    <td>{Money.new(3200, :xof)}</td>
                    <td><span class="badge badge-warning">Low</span></td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    </Layouts.app>
    """
  end
end
