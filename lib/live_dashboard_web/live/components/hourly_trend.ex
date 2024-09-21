defmodule LiveDashboardWeb.Components.HourlyTrend do
  use LiveDashboardWeb, :live_component

  def render(assigns) do
    ~H"""
    <div id="hourly-trend" phx-hook="HourlyTrend" class="bg-white shadow-md rounded-lg p-3 col-span-2 px-2">
    <h2 class="text-xl font-semibold mb-4">Tendance horaire <b><span style="color:#607d8b">7 jours</span></b> vs <b><span style="color:rgba(149, 97, 226, 1)">aujourd'hui</span></b></h2>
      <div class="chart-container">
        <canvas id="trend-chart" width="1000" height="250"></canvas>
        <!--<progress value="45" max="100" class="w-full">15%</progress>-->
      </div>
    </div>
    """
  end

  def update(assigns, socket) do
    {:ok, socket}
  end

  def mount(socket) do
    {:ok, socket}
  end
end
