defmodule LiveDashboardWeb.Components.OrderLinesToday do
  use LiveDashboardWeb, :live_component

  def render(assigns) do
    ~H"""
    <div id="order-lines-today" phx-hook="OrderLinesToday" class="bg-white shadow-md rounded-lg p-3 col-span-1  px-2">
      <h2 class="text-xl font-semibold mb-4">Lignes de commandes <b><span style="color:rgba(149, 97, 226, 1)">aujourd'hui</span></b></h2>
      <div class="chart-container text-justify mx-auto ml-8">
        <span class="inline-block text-black-500 py-1 rounded-full text-5xl leading-tight text-left">
          <span>Total: <span id="comm_today" phx-update="ignore">0</span></span>
          <br/>
          <span class="border-b-4 pb-2">Livrées: (<span id="comm_livrees" phx-update="ignore" style="color:rgba(76, 175, 80, 1)">0</span>)</span>
          <br/>
          <span>Restantes: <span id="comm_restant" phx-update="ignore" style="color:rgba(149, 97, 226, 1)">0</span></span>
        </span>
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
