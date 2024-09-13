defmodule LiveDashboardWeb.IndicatorLive.Show do
  use LiveDashboardWeb, :live_view

  alias LiveDashboard.Dashboard

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:indicator, Dashboard.get_indicator!(id))}
  end

  defp page_title(:show), do: "Show Indicator"
  defp page_title(:edit), do: "Edit Indicator"
end
