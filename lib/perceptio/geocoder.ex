defmodule Perceptio.Geocoder do
  require HTTPoison
  require Logger



  def geocode(address) do
    normalized_address = normalize_address(address)
    token = System.get_env("MAPBOX_ACCESS_TOKEN")
    url = "https://api.mapbox.com/geocoding/v6/forward"

    params = [
      %{
        q: normalized_address,
        limit: 1,
        proximity: "ip",
        access_token: token
      }
    ]

    full_url = url <> "?" <> URI.encode_query(params)

    case HTTPoison.get(full_url) do
      {:ok, %{status: 200, body: body}} ->
        process_geocoding_response(body, normalized_address)
      {:ok, response} ->
        Logger.warning("Unexpected response: #{inspect(response)}")
        {:error, "Unexpected response from geocoding service"}
      {:error, reason} ->
        Logger.error("Geocoding request failed: #{inspect(reason)}")
        {:error, "Geocoding request failed"}
    end
  end

  defp normalize_address(address) do
    address
    |> String.trim()
    |> String.replace(~r/\s+/, " ")
  end

  defp process_geocoding_response(body, address) do
    decoded_body = Jason.decode!(body)
    case Map.get(decoded_body, "features", []) do
      [first_result | _] ->
        extract_geocoding_data(first_result, address)
      _ ->
        Logger.warning("No geocoding results for address: #{address}")
        {:error, "No results found for address: #{address}"}
    end
  end

  defp extract_geocoding_data(result, address) do
    try do
      {:ok, %{
        latitude: get_in(result, ["geometry", "coordinates", 1]),
        longitude: get_in(result, ["geometry", "coordinates", 0]),
        formatted_address: Map.get(result, "place_name", address),
        context: %{
          address: Map.get(result, "address", ""),
          text: Map.get(result, "text", ""),
          place_name: Map.get(result, "place_name", "")
        }
      }}
    rescue
      error ->
        Logger.error("Error extracting geocoding data: #{inspect(error)}")
        {:error, "Failed to process geocoding result"}
    end
  end
end
