defmodule AshPhoenixStarterWeb.Reports.SummariesLive do
  use AshPhoenixStarterWeb, :live_view

  on_mount {AshPhoenixStarterWeb.LiveUserAuth, :live_user_required}

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <Layouts.app uri={@uri} current_user={@current_user} flash={@flash}>
      <div class="navbar">
        <div class="flex-1">
          <a class="btn btn-ghost normal-case text-xl">DMS Summary Reports</a>
        </div>
        <div class="flex-none">
          <button class="btn btn-square btn-ghost">
            <svg
              xmlns="http://www.w3.org/2000/svg"
              fill="none"
              viewBox="0 0 24 24"
              class="inline-block w-5 h-5 stroke-current"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M5 12h.01M12 12h.01M19 12h.01M6 12a1 1 0 11-2 0 1 1 0 012 0zm7 0a1 1 0 11-2 0 1 1 0 012 0zm7 0a1 1 0 11-2 0 1 1 0 012 0z"
              >
              </path>
            </svg>
          </button>
        </div>
      </div>

      <div class="container mx-auto p-1 grid grid-cols-1 md:grid-cols-3 gap-6">
        <!-- Report 1: Sales per Region -->
        <div class="card border border-primary">
          <div class="card-body">
            <h2 class="card-title border-b border-primary/60">Sales per Region</h2>
            <p>Aggregated sales data by geographic region.</p>
            <div class="overflow-x-auto">
              <table class="table w-full">
                <thead>
                  <tr>
                    <th>Region</th>
                    <th>Sales ($)</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td>North</td>
                    <td>150,000</td>
                  </tr>
                  <tr>
                    <td>South</td>
                    <td>120,000</td>
                  </tr>
                  <tr>
                    <td>East</td>
                    <td>180,000</td>
                  </tr>
                  <tr>
                    <td>West</td>
                    <td>130,000</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>
        
    <!-- Report 2: Weekly Sales -->
        <div class="card border border-primary">
          <div class="card-body">
            <h2 class="card-title border-b border-primary/60">Weekly Sales</h2>
            <p>Weekly aggregated sales trends.</p>
            <div class="overflow-x-auto">
              <table class="table w-full">
                <thead>
                  <tr>
                    <th>Week</th>
                    <th>Sales ($)</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td>Week 1</td>
                    <td>50,000</td>
                  </tr>
                  <tr>
                    <td>Week 2</td>
                    <td>60,000</td>
                  </tr>
                  <tr>
                    <td>Week 3</td>
                    <td>55,000</td>
                  </tr>
                  <tr>
                    <td>Week 4</td>
                    <td>70,000</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>
        
    <!-- Report 3: Top 10 Merchants -->
        <div class="card border border-primary">
          <div class="card-body">
            <h2 class="card-title border-b border-primary/60">Top 10 Merchants</h2>
            <p>Ranking of top merchants by sales volume.</p>
            <div class="overflow-x-auto">
              <table class="table w-full">
                <thead>
                  <tr>
                    <th>Merchant</th>
                    <th>Sales ($)</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td>Merchant A</td>
                    <td>100,000</td>
                  </tr>
                  <tr>
                    <td>Merchant B</td>
                    <td>90,000</td>
                  </tr>
                  <tr>
                    <td>Merchant C</td>
                    <td>90,000</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>
        
    <!-- Report 4: Monthly Sales -->
        <div class="card border border-primary">
          <div class="card-body">
            <h2 class="card-title border-b border-primary/60">Monthly Sales</h2>
            <p>Monthly aggregated sales data.</p>
            <div class="overflow-x-auto">
              <table class="table w-full">
                <thead>
                  <tr>
                    <th>Month</th>
                    <th>Sales ($)</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td>January</td>
                    <td>200,000</td>
                  </tr>
                  <tr>
                    <td>February</td>
                    <td>180,000</td>
                  </tr>
                  <tr>
                    <td>March</td>
                    <td>220,000</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>
        
    <!-- Report 9: Distribution Efficiency -->
        <div class="card border border-primary">
          <div class="card-body">
            <h2 class="card-title  border-b border-primary/60">Distribution Efficiency</h2>
            <p>Aggregated efficiency metrics.</p>
            <div class="overflow-x-auto">
              <table class="table w-full">
                <thead>
                  <tr>
                    <th>Region</th>
                    <th>Efficiency (%)</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td>North</td>
                    <td>95</td>
                  </tr>
                  <tr>
                    <td>South</td>
                    <td>90</td>
                  </tr>
                  <tr>
                    <td>East</td>
                    <td>92</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>
        
    <!-- Report 10: Revenue Growth -->
        <div class="card border border-primary">
          <div class="card-body">
            <h2 class="card-title  border-b border-primary/60">Revenue Growth</h2>
            <p>Year-over-year revenue growth.</p>
            <div class="overflow-x-auto">
              <table class="table w-full">
                <thead>
                  <tr>
                    <th>Year</th>
                    <th>Growth (%)</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td>2023</td>
                    <td>10</td>
                  </tr>
                  <tr>
                    <td>2024</td>
                    <td>15</td>
                  </tr>
                  <tr>
                    <td>2025</td>
                    <td>20</td>
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
