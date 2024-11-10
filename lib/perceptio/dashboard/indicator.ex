defmodule Perceptio.Dashboard.Indicator do
  use Ecto.Schema
  import Ecto.Changeset

  schema "indicators" do
    field :description, :string

    timestamps()
  end

  @doc false
  def changeset(indicator, attrs) do
    indicator
    |> cast(attrs, [:description])
    |> validate_required([:description])
  end
end
