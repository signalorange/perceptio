defmodule LiveDashboardWeb.IndicatorLive.Indicators do
  use Phoenix.LiveView

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: send(self(), :refresh)
    {:ok, assign(socket, indicators: %{
			a_faire: 0,
			complete: 0,
			livres: 0,
			total: 0,
			stock: 0,
			stock_complete: 0,
			cable: 0,
			cable_complete: 0,
			ext: 0,
			ext_complete: 0,
			a_faire_300: 0,
			complete_300: 0,
			livres_300: 0,
			a_faire_100: 0,
			complete_100: 0,
			livres_100: 0,
			moyenne: 0
		}), layout: {LiveDashboardWeb.Layouts, :app}}
  end

  @impl true
  def handle_info(:refresh, socket) do
    {:noreply, assign(socket, indicators: %{
			a_faire: 0,
			complete: 0,
			livres: 0,
			total: 0,
			stock: 0,
			stock_complete: 0,
			cable: 0,
			cable_complete: 0,
			ext: 0,
			ext_complete: 0,
			a_faire_300: 0,
			complete_300: 0,
			livres_300: 0,
			a_faire_100: 0,
			complete_100: 0,
			livres_100: 0,
			moyenne: 0
		})}
  end

	# def render(assigns) do
  #   ~H"""
  #   <div id="api-data-container">
	# 		<h1>Data from API</h1>
	# 		<p id="api-data">Loading...</p>
	# 	</div>

	# 	<!-- JavaScript to fetch data from the API -->
	# 	<script>
	# 		document.addEventListener('DOMContentLoaded', function() {
	# 			// Define the API endpoint URL
	# 			const apiUrl = '/api/nb_commandes_ln';  // Replace with your actual API URL

	# 			// Function to fetch data from the API
	# 			function fetchData() {
	# 				fetch(apiUrl)
	# 					.then(response => response.json())  // Parse JSON response
	# 					.then(data => {
	# 						// Update the DOM with the fetched data
	# 						document.getElementById('api-data').innerText = JSON.stringify(data);
	# 					})
	# 					.catch(error => {
	# 						// Handle any errors
	# 						console.error('Error fetching data:', error);
	# 						document.getElementById('api-data').innerText = 'Error loading data';
	# 					});
	# 			}

	# 			// Call fetchData on page load
	# 			fetchData();

	# 			// Optionally, you can refresh the data periodically (e.g., every 5 seconds)
	# 			setInterval(fetchData, 5000*60);  // 5 minutes interval
	# 		});
	# 	</script>

  #   """
  # end

end
