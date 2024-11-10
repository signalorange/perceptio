defmodule PerceptioWeb.Components.OrderLinesTypes do
  use PerceptioWeb, :live_component

  def update(assigns, socket) do
    {:ok, assign(socket, chart_data: assigns.chart_data)}
  end

  def mount(assigns, socket) do
    {:ok, assign(socket, chart_data: assigns.chart_data)}
  end

  def render(assigns) do
    ~H"""
    <div id="order-lines-types"
        phx-hook="OrderLinesTypes"
        data-chart={Jason.encode!(@chart_data)}
        class="bg-white shadow-md rounded-lg p-3 col-span-1 px-2">
      <h2 class="text-xl font-semibold mb-4">Lignes par <b>Catégorie de produit</b></h2>
      <div class="chart-container">
        <canvas id="cable-chart" width="500" height="400"></canvas>
      </div>
    </div>
    """
  end

end
