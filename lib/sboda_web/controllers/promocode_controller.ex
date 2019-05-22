defmodule SbodaWeb.PromocodeController do
  use SbodaWeb, :controller
  alias Sboda.Marketing

  @doc """
  get all promocodes
  """
  def index(conn, _params) do
    all_promocodes = Marketing.get_all_promocodes()

    conn
    |> put_status(:ok)
    |> render("index.json", promocodes: all_promocodes)
  end
end
