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
        color: "rgba(39, 192, 1, 0.5)"
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
      },
      %{
        id: "108",
        name: "Route 108",
        coordinates: [
          [-73.63966, 45.62520],
          [-73.68351, 45.55553],
          [-73.76635, 45.51464],
          [-73.88480, 45.52523],
          [-73.87690, 45.55528],
          [-73.75347, 45.65923],
          [-73.82832, 45.73692],
          [-73.81390, 45.77333],
          [-73.62535, 45.80309],
          [-73.47464, 45.75235],
          [-73.49947, 45.71043],
          [-73.62823, 45.63700],
          [-73.63966, 45.62520]
        ],
        color: "rgba(31, 175, 2, 0.5)"
      },
      %{
        id: "105",
        name: "Route 105",
        coordinates: [
          [
            -73.69862517281291,
            45.43577583083433
          ],
          [
            -73.69578856824002,
            45.44830867159675
          ],
          [
            -73.69484668777682,
            45.46523585197522
          ],
          [
            -73.76429660945061,
            45.50857004139888
          ],
          [
            -73.84588548556599,
            45.5160201015195
          ],
          [
            -73.88645359103934,
            45.467271796998716
          ],
          [
            -73.93762605322125,
            45.45135784947132
          ],
          [
            -73.96707457935275,
            45.44018041568037
          ],
          [
            -74.10999339143518,
            45.4513585662051
          ],
          [
            -74.20945408159677,
            45.48488031518721
          ],
          [
            -74.22579293751262,
            45.460159606581556
          ],
          [
            -74.22518885598843,
            45.462068356703924
          ],
          [
            -74.26300153277055,
            45.325052290438464
          ],
          [
            -74.35607113391771,
            45.32034308634201
          ],
          [
            -74.4326220353087,
            45.27268984019511
          ],
          [
            -74.3507089670214,
            45.213724517032745
          ],
          [
            -74.35238137887669,
            45.21438565542539
          ],
          [
            -74.34641922672434,
            45.2064063647465
          ],
          [
            -74.32528008601591,
            45.198165778406064
          ],
          [
            -74.15955246050652,
            45.23507066940192
          ],
          [
            -74.07768357223448,
            45.220486988535555
          ],
          [
            -73.9948007296094,
            45.23376699199517
          ],
          [
            -73.91439098452868,
            45.31403644314955
          ],
          [
            -73.91432159770845,
            45.31292379151827
          ],
          [
            -73.84694769420962,
            45.370246204376
          ],
          [
            -73.90988281416311,
            45.405544949557196
          ],
          [
            -73.82475723556,
            45.42894987755284
          ],
          [
            -73.72611358714815,
            45.43895466560801
          ],
          [
            -73.69901717989259,
            45.435605630214525
          ],
          [
            -73.69862517281291,
            45.43577583083433
          ]
        ],
        color: "rgba(0, 0, 0, 0.5)"
      },
      %{
        id: "102",
        name: "Route 102",
        coordinates: [
          [
            -73.75751618046411,
            45.65688428914663
          ],
          [
            -73.82863346437676,
            45.73684991689018
          ],
          [
            -73.81262194750332,
            45.77451588722121
          ],
          [
            -74.07498173713225,
            46.11234199249779
          ],
          [
            -74.34370892803378,
            46.196143981615364
          ],
          [
            -74.63029247828767,
            46.20848241878113
          ],
          [
            -74.63770276332905,
            46.081055826572026
          ],
          [
            -74.36618116346284,
            45.93790352353167
          ],
          [
            -74.38144242924363,
            45.725186024837825
          ],
          [
            -74.36735484476489,
            45.564054212195344
          ],
          [
            -74.13545292459693,
            45.47044512364141
          ],
          [
            -74.03920234134901,
            45.45905859335082
          ],
          [
            -73.90459616330588,
            45.52379377775429
          ],
          [
            -73.75751618046411,
            45.65688428914663
          ]

        ],
        color: "rgba(0, 102, 235, 0.5)"
      },
      %{
        id: "107",
        name: "Route 107",
        coordinates: [
          [
            -73.49188771879469,
            45.716315684420664
          ],
          [
            -73.47171665918293,
            45.71054936941442
          ],
          [
            -73.28845714362129,
            45.86289740414588
          ],
          [
            -73.21491104657073,
            45.961366951106356
          ],
          [
            -73.35144265776167,
            46.09738537294501
          ],
          [
            -73.4121493177837,
            46.16905804216114
          ],
          [
            -73.50329338105706,
            46.25753298063404
          ],
          [
            -73.54135817657962,
            46.33295452458739
          ],
          [
            -73.63651249425892,
            46.33402881700118
          ],
          [
            -73.76195561518871,
            46.28593030278344
          ],
          [
            -73.9890885339462,
            46.273456810686184
          ],
          [
            -74.05921041010636,
            46.23630753873661
          ],
          [
            -74.07411494906671,
            46.11525403471262
          ],
          [
            -73.80938472858004,
            45.77170921488775
          ],
          [
            -73.62350133890466,
            45.80391603636272
          ],
          [
            -73.47249324935262,
            45.751634686450416
          ],
          [
            -73.49188771879469,
            45.716315684420664
          ]

        ],
        color: "rgba(235, 0, 0, 0.5)"
      },
      %{
        id: "106",
        name: "Route 106",
        coordinates: [
          [
            -73.00182568821792,
            45.65014388389247
          ],
          [
            -73.01265397765803,
            45.60102823292283
          ],
          [
            -72.84990291354586,
            45.55943458073952
          ],
          [
            -72.70834911966331,
            45.59965767664178
          ],
          [
            -72.79909856156779,
            45.65883790921225
          ],
          [
            -72.71981698795287,
            45.74175476983427
          ],
          [
            -72.66041844229918,
            45.89929038226799
          ],
          [
            -72.74615592512792,
            45.91943819724764
          ],
          [
            -72.90759257048776,
            46.00441193553928
          ],
          [
            -73.12022201173932,
            46.044192499318854
          ],
          [
            -73.1381184178642,
            45.97475340206245
          ],
          [
            -72.99339144871895,
            45.85560035741122
          ],
          [
            -72.87971720995631,
            45.781956426195876
          ],
          [
            -72.97610205965383,
            45.700216498539504
          ],
          [
            -73.00182568821792,
            45.65014388389247
          ]

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