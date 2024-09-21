defmodule LiveDashboardWeb.Components.OrderLinesStatus do
  use LiveDashboardWeb, :live_component

  def render(assigns) do
    ~H"""
    <div id="order-lines-status" phx-hook="OrderLinesStatus" class="bg-white shadow-md rounded-lg p-3 col-span-1  px-2">
    <h2 class="text-xl font-semibold mb-4">État des <b>lignes</b> de commandes</h2>
      <div class="chart-container">
        <canvas id="pie-chart" width="500" height="400"></canvas>
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
