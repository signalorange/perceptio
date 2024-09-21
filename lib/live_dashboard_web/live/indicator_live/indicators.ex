defmodule LiveDashboardWeb.IndicatorLive.Indicators do
  use Phoenix.LiveView

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: send(self(), :refresh)
    {:ok, assign(socket, indicators: %{}), layout: {LiveDashboardWeb.Layouts, :app}}
  end

  @impl true
  def handle_info(:refresh, socket) do
    {:noreply, assign(socket, indicators: %{})}
  end

  @impl true
  def render(assigns) do
      ~H"""
      <div class="container mx-auto">
          <div class="grid grid-cols-3 gap-4 mb-4">
          <.live_component module={LiveDashboardWeb.Components.OrderLinesToday} id="order-lines-today" />
          <.live_component module={LiveDashboardWeb.Components.HourlyTrend} id="hourly-trend" />
        </div>
        <div class="grid grid-cols-3 gap-4 mb-4">
          <.live_component module={LiveDashboardWeb.Components.OrderLinesStatus} id="order-line-status" />
          <.live_component module={LiveDashboardWeb.Components.OrderLinesTypes} id="order-line-types" />
          <.live_component module={LiveDashboardWeb.Components.OrderLinesRoutes} id="order-line-routes" />
        </div>
        </div>
      """
    end

end
