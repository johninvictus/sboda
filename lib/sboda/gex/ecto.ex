if Code.ensure_loaded?(Ecto.Type) do
  defmodule Sboda.Gex.Ecto do
    @behaviour Ecto.Type
    @moduledoc """
      This module will convert my custom latitude and longitude to GEO struct

      This will allow me plug PostGis extention when I need it without
       too much setup or refacturing of code
    """

    def type, do: :gex

    def cast(_), do: :error

    def load({latitude, longitude}) when is_float(latitude) and is_float(longitude) do
      {:ok, %Geo.Point{coordinates: {longitude, latitude}, srid: 4326}}
    end

    def load(_), do: :error

    def dump(%Geo.Point{coordinates: {longitude, latitude}, srid: 4326}) do
      {:ok, {latitude, longitude}}
    end

    def dump(_), do: :error
  end
end
