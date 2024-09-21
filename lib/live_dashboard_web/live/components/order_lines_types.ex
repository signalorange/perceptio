defmodule LiveDashboardWeb.Components.OrderLinesTypes do
  use LiveDashboardWeb, :live_component

  def render(assigns) do
    ~H"""
    <div id="order-lines-types" phx-hook="OrderLinesTypes" class="bg-white shadow-md rounded-lg p-3 col-span-1  px-2">
      <h2 class="text-xl font-semibold mb-4">Lignes par <b>Catégorie de produit</b></h2>
      <div class="chart-container">
        <canvas id="cable-chart" width="500" height="400"></canvas>
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
