defmodule SbodaWeb.RideController do
  use SbodaWeb, :controller

  alias Sboda.Ride

  action_fallback(SbodaWeb.FallbackController)

  @doc """
  This will request the ride and return promocode and polyline if promocode is provide
      else
          Return only polylines
  """
  def request(conn, param) do
    with {:ok, promocode, polyline_string, decoded_polylines} <- Ride.request(param) do

      conn
      |> put_status(:ok)
      |> render("request.json", promocode: promocode, polyline_string: polyline_string, decoded_polylines: decoded_polylines)
    end
  end
end
