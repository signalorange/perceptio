defmodule CableDashboard.Orders.Order do
  @moduledoc """
  Schema for a cable cutting order.
  """

  defstruct [
    :id,
    :order_number,
    :product,
    :length,
    :location,
    :status,
    :route,
    :cutoff_time,
    :priority
  ]

  def new(attrs) do
    struct(__MODULE__, attrs)
  end
end

# lib/cable_dashboard/orders.ex
defmodule CableDashboard.Orders do
  @moduledoc """
  Context module for managing cable cutting orders.
  """

  alias CableDashboard.Orders.Order

  @initial_orders [
    %{
      id: 1,
      order_number: "CO002854",
      product: "142NMD90C",
      length: "25m",
      location: "A12",
      status: "En cours de pick",
      route: "Route-1",
      cutoff_time: "14:00"
    },
    %{
      id: 2,
      order_number: "CO002854",
      product: "103CNMWUC",
      length: "15m",
      location: "A13",
      status: "En cours de pick",
      route: "Route-1",
      cutoff_time: "14:00"
    },
    %{
      id: 3,
      order_number: "CO002855",
      product: "103CNMWUC",
      length: "30m",
      location: "A12",
      status: "Imprimé",
      route: "Route-2",
      cutoff_time: "16:00"
    },
    %{
      id: 4,
      order_number: "CO002856",
      product: "142NMD90C",
      length: "20m",
      location: "B01",
      status: "À faire",
      route: "Route-1",
      cutoff_time: "14:00"
    },
    %{
      id: 5,
      order_number: "CO002857",
      product: "124TECK",
      length: "40m",
      location: "A14",
      status: "Sur convoyeurs",
      route: "Route-3",
      cutoff_time: "18:00"
    },
    %{
      id: 6,
      order_number: "CO002858",
      product: "123TECK",
      length: "10m",
      location: "B02",
      status: "Imprimé",
      route: "Route-2",
      cutoff_time: "16:00"
    },
    %{
      id: 7,
      order_number: "CO002859",
      product: "142NMD90C",
      length: "35m",
      location: "B01",
      status: "À faire",
      route: "Route-1",
      cutoff_time: "14:00"
    },
    %{
      id: 8,
      order_number: "CO002860",
      product: "142NMD90C",
      length: "45m",
      location: "A12",
      status: "Sur convoyeurs",
      route: "Route-3",
      cutoff_time: "18:00"
    }
  ]

  def list_orders do
    @initial_orders
    |> Enum.map(&(Order.new(&1) |> Map.put(:priority, get_base_priority(&1.status))))
    |> Enum.sort_by(& &1.priority, :desc)
  end

  def get_base_priority(status) do
    case status do
      "Sur convoyeurs" -> 4.0
      "En cours de pick" -> 3.0
      "Imprimé" -> 2.0
      _ -> 1.0
    end
  end

  def nearby_location?(loc1, loc2) do
    [aisle1, pos1] = String.split(loc1, ~r/(?<=[A-Z])(?=\d)/)
    [aisle2, pos2] = String.split(loc2, ~r/(?<=[A-Z])(?=\d)/)

    aisle1 == aisle2 && abs(String.to_integer(pos1) - String.to_integer(pos2)) <= 2
  end
end
