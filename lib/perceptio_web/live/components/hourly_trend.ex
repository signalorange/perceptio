defmodule PerceptioWeb.Components.HourlyTrend do
  use PerceptioWeb, :live_component


  def update(assigns, socket) do
    {:ok, assign(socket,
      chart_data_live:  assigns.chart_data_live,
      chart_data_today: assigns.chart_data_today,
      chart_data_week: assigns.chart_data_week)
    }
  end

  def mount(assigns, socket) do
    {:ok, assign(socket,
      chart_data_live:  assigns.chart_data_live,
      chart_data_today: assigns.chart_data_today,
      chart_data_week: assigns.chart_data_week)
    }
  end

  def render(assigns) do
    ~H"""
    <div id="hourly-trend"
        phx-hook="HourlyTrend"
        data-chart_live={Jason.encode!(@chart_data_live)}
        data-chart_today={Jason.encode!(@chart_data_today)}
        data-chart_week={Jason.encode!(@chart_data_week)}
        class="bg-white shadow-md rounded-lg p-3 col-span-2 px-2">
    <h2 class="text-xl font-semibold mb-4">Tendance horaire <b><span style="color:#607d8b">14 jours</span></b> vs <b><span style="color:rgba(149, 97, 226, 1)">aujourd'hui</span></b></h2>
      <div class="chart-container">
        <canvas id="trend-chart" width="1000" height="250"></canvas>
        <!--<progress value="45" max="100" class="w-full">15%</progress>-->
      </div>
    </div>
    """
  end

end
