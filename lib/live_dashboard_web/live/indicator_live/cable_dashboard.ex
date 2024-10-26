defmodule LiveDashboardWeb.IndicatorLive.CableDashboardLive do
  use Phoenix.LiveView
  alias CableDashboard.Orders
  alias CableDashboard.Orders.Order

  def mount(_params, _session, socket) do
    orders = Orders.list_orders()

    socket = assign(socket,
      orders: orders,
      selected_id: nil,
      priority_changes: %{}
    )

    {:ok, socket, layout: {LiveDashboardWeb.Layouts, :app}}
  end

  def handle_event("select", %{"id" => id}, socket) do
    id = String.to_integer(id)
    selected_order = Enum.find(socket.assigns.orders, &(&1.id == id))

    {updated_orders, changes} = calculate_priorities(selected_order)

    socket = assign(socket,
      orders: updated_orders,
      selected_id: id,
      priority_changes: changes
    )

    {:noreply, socket}
  end

  defp calculate_priorities(selected_order) do
    base_orders = Orders.list_orders()
    changes = %{}

    {updated_orders, final_changes} = Enum.reduce(base_orders, {[], changes}, fn order, {acc_orders, acc_changes} ->
      if order.id == selected_order.id do
        # Set a high priority if it's the selected order
        {[%{order | priority: 100.0} | acc_orders], acc_changes}
      else
        # Initial values for priority and change tag
        {new_priority, change_tag} = cond do
          order.order_number == selected_order.order_number ->
            {order.priority + 5.0, "commande"}

          order.product == selected_order.product ->
            {order.priority + 3.0, "produit"}

          Orders.nearby_location?(order.location, selected_order.location) ->
            {order.priority + 1.0, "proximité"}

          true ->
            {order.priority, nil}
        end

        # Update acc_changes only if there's a change tag
        new_acc_changes = if change_tag do
          Map.put(acc_changes, order.id, [change_tag])
        else
          acc_changes
        end

        {[%{order | priority: new_priority} | acc_orders], new_acc_changes}
      end
    end)


    sorted_orders = Enum.sort_by(updated_orders, & &1.priority, :desc)
    {sorted_orders, final_changes}
  end

  defp status_color(status) do
    case status do
      "Sur convoyeurs" -> "bg-green-100"
      "En cours de pick" -> "bg-blue-100"
      "Imprimé" -> "bg-orange-100"
      _ -> "bg-red-100"
    end
  end

  defp status_text_color(status) do
    case status do
      "Sur convoyeurs" -> "text-green-800"
      "En cours de pick" -> "text-blue-800"
      "Imprimé" -> "text-orange-800"
      _ -> "text-red-800"
    end
  end

  @impl true
  def render(assigns) do
      ~H"""
      <div class="p-6 max-w-6xl mx-auto">
        <h1 class="text-2xl font-bold mb-6">Tableau de priorité des coupes de câbles</h1>

        <div class="bg-white rounded-lg shadow overflow-hidden">
          <table class="w-full">
            <thead>
              <tr class="bg-gray-50">
                <th class="px-4 py-3 text-left">Priorité</th>
                <th class="px-4 py-3 text-left">Commande</th>
                <th class="px-4 py-3 text-left">Produit</th>
                <th class="px-4 py-3 text-left">Longueur</th>
                <th class="px-4 py-3 text-left">Emplacement</th>
                <th class="px-4 py-3 text-left">Statut</th>
                <th class="px-4 py-3 text-left">Route</th>
                <!--<th class="px-4 py-3 text-left">Heure Limite</th>
                <th class="px-4 py-3 text-left">Action</th>-->
              </tr>
            </thead>
            <tbody>
              <%= for order <- @orders do %>
                <tr class={[
                  "border-t transition-all duration-300",
                  if(@selected_id == order.id, do: "bg-purple-100", else: status_color(order.status)),
                  "hover:bg-gray-50 cursor-pointer"
                ]}
                phx-click="select"
                      phx-value-id={order.id}>
                  <td class="px-4 py-3">
                    <div class="flex flex-col gap-1">
                      <span class="font-semibold"><%= :erlang.float_to_binary(order.priority, decimals: 2) %></span>
                      <%= if changes = @priority_changes[order.id] do %>
                        <%= for change <- changes do %>
                          <div class="flex items-center gap-1 text-sm">

                            <span class="text-green-600">
                              <%= case change do %>
                                <% "commande" -> %>Même commande (+5)
                                <% "produit" -> %>Même produit (+3)
                                <% "proximité" -> %>Proximité (+1)
                              <% end %>
                            </span>
                          </div>
                        <% end %>
                      <% end %>
                    </div>
                  </td>
                  <td class="px-4 py-3"><%= order.order_number %></td>
                  <td class="px-4 py-3"><%= order.product %></td>
                  <td class="px-4 py-3"><%= order.length %></td>
                  <td class="px-4 py-3">
                    <div class="flex items-center gap-2">

                      <%= order.location %>
                    </div>
                  </td>
                  <td class="px-4 py-3">
                    <span class={[
                      "px-2 py-1 rounded-full text-sm",
                      status_color(order.status),
                      status_text_color(order.status)
                    ]}>
                      <%= order.status %>
                    </span>
                  </td>
                  <td class="px-4 py-3"><%= order.route %></td>
                  <!--<td class="px-4 py-3">
                    <div class="flex items-center gap-2">

                      <%= order.cutoff_time %>
                    </div>
                  </td>
                  <td class="px-4 py-3">
                    <button
                      class="px-3 py-2 bg-blue-500 text-white rounded-md hover:bg-blue-600 flex items-center gap-2"
                      phx-click="select"
                      phx-value-id={order.id}
                    >

                      Sélectionner
                    </button>
                  </td>-->
                </tr>
              <% end %>
            </tbody>
          </table>
        </div>
      </div>
      """
    end
end
