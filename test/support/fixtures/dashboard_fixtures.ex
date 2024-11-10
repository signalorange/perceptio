defmodule Perceptio.DashboardFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Perceptio.Dashboard` context.
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
      |> Perceptio.Dashboard.create_indicator()

    indicator
  end
end
