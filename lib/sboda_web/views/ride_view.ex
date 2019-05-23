defmodule SbodaWeb.RideView do
  use SbodaWeb, :view

  alias SbodaWeb.PromocodeView
  alias __MODULE__

  def render(
        "request.json",
        %{
          promocode: promocode,
          polyline_string: polyline_string,
          decoded_polylines: decoded_polylines
        }
      ) do

    convert_polylines_map =
      decoded_polylines
      |> Enum.map(fn polyline ->
        {longt, lat} = polyline
        %{latitude: lat, longitude: longt}
      end)

    %{
      data: %{
        promocode: render_one(promocode, PromocodeView, "promocode.json", as: :promocode),
        polyline_string: polyline_string,
        decoded_polylines:
          render_many(convert_polylines_map, RideView, "coordinate.json", as: :coordinate)
      }
    }
  end

  def render("coordinate.json", %{coordinate: coord}) do
    %{
      latitude: coord.latitude,
      longitude: coord.longitude
    }
  end
end
