defmodule SbodaWeb.PromocodeController do
  use SbodaWeb, :controller
  alias Sboda.Marketing

  action_fallback(SbodaWeb.FallbackController)

  @doc """
  get all promocodes
  """
  def index(conn, _params) do
    all_promocodes = Marketing.get_all_promocodes()

    conn
    |> put_status(:ok)
    |> render("index.json", promocodes: all_promocodes)
  end

  @doc """
  Required fields

  [:title, :lat, :logt, :expir_str, :worth_str, :distance, :currency]
    :active is not required

    This will create a new promocode
  """
  def create(conn, params) do

    with {:ok, promo} <- Marketing.create_promocode(params) do
      conn
      |> put_status(:created)
      |> render("create.json", promocode: promo)
    end
  end

  @doc """
  This function is going to retrieve all active promocodes
  """
  def active(conn, _params) do
    with p_list when is_list(p_list) <- Marketing.get_active_promocodes()  do
      conn
      |> put_status(:ok)
      |> render("active.json", promocodes: p_list)

    else
      _->
      {:error, "Something went wrong"}
    end
  end

  @doc """
  change radius of promocode when given its title
  """
def config_radius(conn, %{"title" => title, "radius" => radius}) do
    with {:ok, promo} <- Marketing.change_radius(title, radius) do
      conn
      |> put_status(:ok)
      |> render("title_config.json", promocode: promo)
    end
  end

  def config_radius(_conn, _param) do
    {:error, "Provide valid parameters"}
  end
end
