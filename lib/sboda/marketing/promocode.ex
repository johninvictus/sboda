defmodule Sboda.Marketing.Promocode do

  @moduledoc """
  This module will only take valid fields after being validated by the programmer
    - I could have validated and converted the raw data here but I have decide to pass that responsibility to the
      params embedded schema 
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Sboda.Money

  schema "promocodes" do
    field :title, :string
    field :point, Geo.PostGIS.Geometry #where the event is located
    field :active, :boolean
    field :expir, :naive_datetime
    field :worth, Money.Ecto
    field :distance, :float

    timestamps()
    
  end

  @doc false
  def changeset(promocode, attrs) do
    promocode
    |> cast(attrs, [:title, :point, :active, :expir, :worth, :distance])
    |> validate_required([:title, :point, :expir, :worth, :distance]) # exclude active since it has a default value
  end

end
