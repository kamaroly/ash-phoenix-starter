defmodule AshPhoenixStarterWeb.Reports.GraphsLive do
  use AshPhoenixStarterWeb, :live_view

  on_mount {AshPhoenixStarterWeb.LiveUserAuth, :live_user_required}

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <Layouts.app uri={@uri} current_user={@current_user} flash={@flash}>
      <div class="card"></div>

      <div class="container mx-auto p-1 grid grid-cols-1 md:grid-cols-3 gap-6">
        <!-- Report 1: Sales per Region -->
        <div class="card border border-primary">
          <div class="card-body">
            <h2 class="card-title border-b border-primary/60">Sales per Region</h2>
            <p>Aggregated sales data by geographic region.</p>
            <div class="overflow-x-auto">
              <AshPhoenixStarterWeb.Chart.chart type="bar" />
            </div>
          </div>
        </div>
        
    <!-- Report 2: Weekly Sales -->
        <div class="card border border-primary">
          <div class="card-body">
            <h2 class="card-title border-b border-primary/60">Weekly Sales</h2>
            <p>Weekly aggregated sales trends.</p>
            <div class="overflow-x-auto">
              <AshPhoenixStarterWeb.Chart.chart type="line" />
            </div>
          </div>
        </div>
        
    <!-- Report 3: Top 10 Merchants -->
        <div class="card border border-primary">
          <div class="card-body">
            <h2 class="card-title border-b border-primary/60">Top 10 Merchants</h2>
            <p>Ranking of top merchants by sales volume.</p>
            <div class="overflow-x-auto">
              <AshPhoenixStarterWeb.Chart.chart type="radar" />
            </div>
          </div>
        </div>
        
    <!-- Report 4: Monthly Sales -->
        <div class="card border border-primary">
          <div class="card-body">
            <h2 class="card-title border-b border-primary/60">Monthly Sales</h2>
            <p>Monthly aggregated sales data.</p>
            <div class="overflow-x-auto">
              <AshPhoenixStarterWeb.Chart.chart type="doughnut" />
            </div>
          </div>
        </div>
        
    <!-- Report 9: Distribution Efficiency -->
        <div class="card border border-primary">
          <div class="card-body">
            <h2 class="card-title  border-b border-primary/60">Distribution Efficiency</h2>
            <p>Aggregated efficiency metrics.</p>
            <div class="overflow-x-auto">
              <AshPhoenixStarterWeb.Chart.chart type="bubble" />
            </div>
          </div>
        </div>
        
    <!-- Report 10: Revenue Growth -->
        <div class="card border border-primary">
          <div class="card-body">
            <h2 class="card-title  border-b border-primary/60">Revenue Growth</h2>
            <p>Year-over-year revenue growth.</p>
            <div class="overflow-x-auto">
              <AshPhoenixStarterWeb.Chart.chart type="line" />
            </div>
          </div>
        </div>
      </div>
    </Layouts.app>
    """
  end
end
