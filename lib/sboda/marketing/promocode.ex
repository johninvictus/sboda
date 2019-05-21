defmodule Sboda.Marketing.Promocode do
  @moduledoc """
  This module takes will take raw input
    |> validate them 
    |> convert the to required format

    Giving this module validation power will reduce amount of code writed at the Web Module
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Sboda.Money

  schema "promocodes" do
    field :title, :string
    # where the event is located
    field :point, Geo.PostGIS.Geometry
    field :active, :boolean
    field :expir, :naive_datetime
    field :worth, Money.Ecto
    field :distance, :float

    # virtual fields to receive raw params
    # will be converted to points
    field :lat, :float, virtual: true
    field :logt, :float, virtual: true
    # expir virtual field
    field :expir_str, :string, virtual: true
    # worth string()
    field :worth_str, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(promocode, attrs) do
    promocode
    |> cast(attrs, [:title, :lat, :logt, :expir_str, :worth_str, :active, :distance])
    # exclude active since it has a default value
    |> validate_required([:title, :lat, :logt, :expir_str, :worth_str, :active, :distance])
    |> create_point()
  end


  # This functions takes in latitude and longitude and converts them into a Geo.Point
  defp create_point(changeset) do
    if(changeset.valid?) do
      data = changeset |> apply_changes()
      # the first value is logitude the other is latitude
      changeset
      |> put_change(:point, %Geo.Point{coordinates: {data.logt, data.lat}, srid: 4326})
    else
      changeset
    end
  end
end
