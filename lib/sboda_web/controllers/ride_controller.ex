defmodule SbodaWeb.RideController do
  use SbodaWeb, :controller
  require Logger

  @doc """
  This will request the ride and return promocode and polyline if promocode is provide
      else
          Return only polylines
  """
  def request(conn, param) do
    Logger.debug(param)
  end
end
