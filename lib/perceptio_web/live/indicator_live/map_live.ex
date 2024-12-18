defmodule PerceptioWeb.IndicatorLive.MapLive do
  use PerceptioWeb, :live_view

  def mount(_params, _session, socket) do
    polygons = [
      %{
        id: "101",
        name: "Route 101",
        coordinates: [
          [-73.49765, 45.42055],
          [-73.26759, 45.34140],
          [-73.09657, 45.43716],
          [-73.08613, 45.33793],
          [-73.01937, 45.28996],
          [-73.06744, 45.19834],
          [-73.12421, 45.09056],
          [-73.21485, 45.01683],
          [-74.15988, 45.00694],
          [-74.00670, 45.22280],
          [-73.89575, 45.31386],
          [-73.68358, 45.41501],
          [-73.52675, 45.40069],
          [-73.49765, 45.42055]
        ],
        color: "rgba(0, 78, 247, 0.5)"
      },
      %{
        id: "103",
        name: "Route 103",
        coordinates: [
          [-73.49765, 45.42055],
          [-73.26759, 45.34140],
          [-73.09657, 45.43716],
          [-73.09442, 45.59671],
          [-72.87399, 45.60691],
          [-72.65899, 45.89916],
          [-72.74587, 45.92018],
          [-72.90655, 46.00418],
          [-73.11872, 46.04471],
          [-73.20798, 45.90489],
          [-73.42977, 45.71967],
          [-73.45930, 45.59873],
          [-73.52521, 45.52566],
          [-73.49765, 45.42055]
        ],
        color: "rgba(0, 156, 247, 0.5)"
      },
      %{
        id: "109",
        name: "Route 109",
        coordinates: [
          [-73.56939, 45.53061],
          [-73.54312, 45.53111],
          [-73.50754, 45.58508],
          [-73.48271, 45.69952],
          [-73.61522, 45.63213],
          [-73.66055, 45.57255],
          [-73.56939, 45.53061]
        ],
        color: "rgba(156, 6, 216, 0.5)"
      },
      %{
        id: "104",
        name: "Route 104",
        coordinates: [
          [-73.66055, 45.57255],
          [-73.56939, 45.53061],
          [-73.54312, 45.53111],
          [-73.53954, 45.48848],
          [-73.53319, 45.46741],
          [-73.61078, 45.41642],
          [-73.75910, 45.50913],
          [-73.66159, 45.57141],
          [-73.66055, 45.57255]
        ],
        color: "rgba(235, 0, 0, 0.5)"
      }
    ]

    {:ok,
      socket
      |> assign(:polygons, polygons)
      |> assign(:geocode_result, nil)
      |> assign(:address_input, "")}
  end

  def render(assigns) do
    ~H"""
    <div>
      <div
        id="map"
        phx-hook="MapboxInteraction"
        style="height: 800px; width: 100%;"
        data-polygons={Jason.encode!(@polygons)}
        data-mapbox-token={System.get_env("MAPBOX_ACCESS_TOKEN")}
      >
      </div>

      <%!-- <form phx-submit="geocode_address">
        <input
          type="text"
          name="address"
          placeholder="Enter an address"
          value={@address_input}
        />
        <button type="submit">Geocode</button>
      </form> --%>

      <%= if @geocode_result do %>
        <div>
          Geocoded Location:
          Latitude: <%= @geocode_result.latitude %>
          Longitude: <%= @geocode_result.longitude %>
          Address: <%= @geocode_result.formatted_address %>
        </div>
      <% end %>
    </div>
    """
  end

  def handle_event("geocode_address", %{"address" => address}, socket) do
    case Perceptio.Geocoder.geocode(address) do
      {:ok, result} ->
        # Update map center or add marker
        {:noreply,
          socket
          |> assign(:geocode_result, result)
          |> push_event("map-center", %{
            lat: result.latitude,
            lon: result.longitude
          })}
      {:error, error_message} ->
        {:noreply,
          socket
          |> put_flash(:error, error_message)}
    end
  end

  defp geocode_address(address) do
    # Geocoding implementation
    case Perceptio.Geocoder.geocode(address) do
      {:ok, result} -> {:ok, result}
      _ -> {:error, "Geocoding failed"}
    end
  end
end
