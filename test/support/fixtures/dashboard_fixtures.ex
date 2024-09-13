defmodule LiveDashboard.DashboardFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LiveDashboard.Dashboard` context.
  """

  @doc """
  Generate a indicator.
  """
  def indicator_fixture(attrs \\ %{}) do
    {:ok, indicator} =
      attrs
      |> Enum.into(%{
        description: "some description"
      })
      |> LiveDashboard.Dashboard.create_indicator()

    indicator
  end
end
