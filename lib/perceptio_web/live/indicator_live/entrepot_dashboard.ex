defmodule PerceptioWeb.IndicatorLive.EntrepotDashboard do
  use PerceptioWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Phoenix.PubSub.subscribe(Perceptio.PubSub, "order_lines_status")
      Phoenix.PubSub.subscribe(Perceptio.PubSub, "order_lines_types")
      Phoenix.PubSub.subscribe(Perceptio.PubSub, "order_lines_routes")
      Phoenix.PubSub.subscribe(Perceptio.PubSub, "hourly_trend_today")
      Phoenix.PubSub.subscribe(Perceptio.PubSub, "hourly_trend_week")
    end

    order_lines_status = Perceptio.DataStore.get_order_lines_status()
    order_lines_types = Perceptio.DataStore.get_order_lines_types()
    order_lines_routes = Perceptio.DataStore.get_order_lines_routes()
    hourly_trend_today = Perceptio.DataStore.get_hourly_trend_today()
    hourly_trend_week = Perceptio.DataStore.get_hourly_trend_week()

    {:ok,
     assign(socket,
       order_lines_status: order_lines_status,
       order_lines_types: order_lines_types,
       order_lines_routes: order_lines_routes,
       hourly_trend_today: hourly_trend_today,
       hourly_trend_week: hourly_trend_week
     )}
  end

  @impl true
  def handle_info({:order_lines_status_updated, new_data}, socket) do
    {:noreply, assign(socket, order_lines_status: new_data)}
  end

  def handle_info({:order_lines_types_updated, new_data}, socket) do
    {:noreply, assign(socket, order_lines_types: new_data)}
  end

  def handle_info({:order_lines_routes_updated, new_data}, socket) do
    {:noreply, assign(socket, order_lines_routes: new_data)}
  end

  def handle_info({:hourly_trend_today_updated, new_data}, socket) do
    {:noreply, assign(socket, hourly_trend_today: new_data)}
  end

  def handle_info({:hourly_trend_week_updated, new_data}, socket) do
    {:noreply, assign(socket, hourly_trend_week: new_data)}
  end

  @impl true
  @spec render(any()) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
      ~H"""
      <div class="container mx-auto">
          <div class="grid grid-cols-3 gap-4 mb-4">
          <.live_component module={PerceptioWeb.Components.OrderLinesToday}
                          id="order-lines-today"
                          chart_data={@order_lines_status} />
          <.live_component module={PerceptioWeb.Components.HourlyTrend}
                          id="hourly-trend"
                          chart_data_today={@hourly_trend_today}
                          chart_data_week={@hourly_trend_week} />
        </div>
        <div class="grid grid-cols-3 gap-4 mb-4">
          <.live_component module={PerceptioWeb.Components.OrderLinesStatus}
                          id="order-line-status"
                          chart_data={@order_lines_status}/>
          <.live_component module={PerceptioWeb.Components.OrderLinesTypes}
                          id="order-line-types"
                          chart_data={@order_lines_types}/>
          <.live_component module={PerceptioWeb.Components.OrderLinesRoutes}
                          id="order-line-routes"
                          chart_data={@order_lines_routes}/>
        </div>
        </div>
      """
    end
end
