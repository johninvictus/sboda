defmodule SbodaWeb.PageController do
  use SbodaWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
