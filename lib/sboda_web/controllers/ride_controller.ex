defmodule SbodaWeb.RideController do
  use SbodaWeb, :controller

  @doc """
  This will request the ride and return promocode and polyline if promocode is provide
      else
          Return only polylines
  """
  def request(conn, %{"rideinfo" => rideinfo}) do
    
  end
end
