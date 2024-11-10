defmodule Perceptio.Dashboard do
  @moduledoc """
  The Dashboard context.
  """

  import Ecto.Query, warn: false
  alias Perceptio.Repo

  alias Perceptio.Dashboard.Indicator

  @doc """
  Returns the list of indicators.

  ## Examples

      iex> list_indicators()
      [%Indicator{}, ...]

  """
  def list_indicators do
    Repo.all(Indicator)
  end

  @doc """
  Gets a single indicator.

  Raises `Ecto.NoResultsError` if the Indicator does not exist.

  ## Examples

      iex> get_indicator!(123)
      %Indicator{}

      iex> get_indicator!(456)
      ** (Ecto.NoResultsError)

  """
  def get_indicator!(id), do: Repo.get!(Indicator, id)

  @doc """
  Creates a indicator.

  ## Examples

      iex> create_indicator(%{field: value})
      {:ok, %Indicator{}}

      iex> create_indicator(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_indicator(attrs \\ %{}) do
    %Indicator{}
    |> Indicator.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a indicator.

  ## Examples

      iex> update_indicator(indicator, %{field: new_value})
      {:ok, %Indicator{}}

      iex> update_indicator(indicator, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_indicator(%Indicator{} = indicator, attrs) do
    indicator
    |> Indicator.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a indicator.

  ## Examples

      iex> delete_indicator(indicator)
      {:ok, %Indicator{}}

      iex> delete_indicator(indicator)
      {:error, %Ecto.Changeset{}}

  """
  def delete_indicator(%Indicator{} = indicator) do
    Repo.delete(indicator)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking indicator changes.

  ## Examples

      iex> change_indicator(indicator)
      %Ecto.Changeset{data: %Indicator{}}

  """
  def change_indicator(%Indicator{} = indicator, attrs \\ %{}) do
    Indicator.changeset(indicator, attrs)
  end
end
