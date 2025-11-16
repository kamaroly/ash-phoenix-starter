defmodule AshPhoenixStarterWeb.Chart do
  use AshPhoenixStarterWeb, :html

  @default_datasets [
    %{
      data: [120, 140, 180],
      label: "Actual",
      borderColor: "#00b300",
      tension: 0.3,
      borderWidth: 2,
      pointRadius: 5,
      backgroundColor: "#00b300"
    },
    %{
      data: [nil, nil, nil, 360, 340, 320, 300],
      label: "Predicted",
      borderColor: "#000",
      tension: 0.3,
      borderWidth: 2,
      borderDash: [5, 5],
      pointRadius: 3,
      backgroundColor: "#ffcc07"
    }
  ]

  attr :type, :string, default: "bar"
  attr :x_title, :string, default: "My Chart X title"
  attr :y_title, :string, default: "My Chart Y title"
  attr :legend_position, :string, default: "top"
  attr :labels, :list, default: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
  attr :datasets, :list, default: @default_datasets

  def chart(assigns) do
    ~H"""
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js" />
    <div id="chart-container">
      <canvas
        id={"chart-#{ Ash.UUIDv7.generate()}"}
        phx-hook=".Chart"
        type={@type}
        x_title={@y_title}
        y_title={@y_title}
        labels={Jason.encode!(@labels)}
        datasets={Jason.encode!(@datasets)}
        legend_position={@legend_position}
      >
      </canvas>
    </div>
    <script :type={Phoenix.LiveView.ColocatedHook} name=".Chart">
        export default {
             mounted() {

      const ctx = this.el.getContext("2d");
      const labels = JSON.parse(this.el.getAttribute('labels'))
      const actualData = [120, 140, 180, 210, 240, 260];
      const predictedData = [null, null, null, 360, 340, 320, 300];

      this.chart = new Chart(ctx, {
        type: this.el.getAttribute('type'),
        data: {
          labels:  labels,
          datasets: JSON.parse(this.el.getAttribute('datasets')),
        },
        options: {
          responsive: true,
          scales: {
            x: {title: { display: true, text: this.el.getAttribute('x_title') }},
            y: {title: { display: true, text: this.el.getAttribute('y_title') }},
          },
          plugins: {
            legend: {
              position: this.el.getAttribute('legend_position'),
              labels: {
                    color: "#000",
                    font: {
                        weight: 100,
                        size: 16 // Set the desired font size here (e.g., 20px)
                    }
                }},
          },
        },
      });

      }
        }
    </script>
    """
  end
end
