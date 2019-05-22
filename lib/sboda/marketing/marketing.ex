defmodule Sboda.Marketing do
  @moduledoc """
  The Marketing context.
  """

  import Ecto.Query, warn: false
  alias Sboda.Repo

  alias Sboda.Marketing.Promocode

  @doc """
  Creates the promocode when given a Map.

  # Example
    iex> Sboda.Marketing.create_promocode(%{ all data here})
      {:ok, %Sboda.Marketing.Promocode{}}

    iex> Sboda.Marketing.create_promocode(%{ all data here})
       {:error, %Ecto.Changeset{}}
  """

  def create_promocode(attr \\ Map.new()) do
    %Promocode{}
    |> Promocode.changeset(attr)
    |> Repo.insert()
  end

  @doc """
  Returns all promocodes in the database

   ## Example

    iex> Sboda.Marketing.get_all_pomocodes()
  """
  @spec get_all_promocodes() :: list(%Promocode{}) | []
  def get_all_promocodes do
    Promocode |> Repo.all()
  end

  @doc """
  get promocode by title

  ## Example
  iex> Sboda.Marketing.get_promocode_by_title/1
      %Sboda.Marketing.Promocode{}

   iex> Sboda.Marketing.get_promocode_by_title/1
      nil
  """

  def get_promocode_by_title(title) do
    Promocode |> Repo.get_by(title: title)
  end

  @doc """
  Get active promocode by title

  ## EXAMPLE
  iex> get_active_promocode_by_title
    %Promocode

    iex> get_active_promocode_by_title
      nil
  """
  def get_active_promocode_by_title(title) do
    Promocode
    |> promocode_by_title_query(title)
    |> active_promo_query
    |> Repo.one()
  end

  @doc """
    get promocode by ID

    ## Example

  valid id
  iex> Sboda.Marketing.get_promocode_by_id/1
      %Sboda.Marketing.Promocode{}

  invalid id
   iex> Sboda.Marketing.get_promocode_by_id/1
      nil
  """
  def get_promocode_by_id(id) do
    Promocode |> Repo.get(id)
  end

  @doc """
  Return only the valid promocodes active = true and expir < date now

  ## Example
  iex> Sboda.Marketing.get_active_promocode()
    [%Sboda.Marketing.Promocode{}]

  iex> Sboda.Marketing.get_active_promocode()
    []
  """
  def get_active_promocodes do
    Promocode
    |> active_promo_query()
    |> Repo.all()
  end

  @doc """
  update promocode / configure promo code

   iex> Sboda.Marketing.update_promocode(%Promocode{})
    %Sboda.Marketing.Promocode{}

  """
  def update_promocode(%Promocode{} = promocode, attrs) do
    promocode
    |> Promocode.update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
    will generate a query to fetch all active promocodes without pagination
    I have used this function, so that I can reuse it later (can be resused multiple times)
  """
  def active_promo_query(query) do
    # using the UTC time, not sure which is the best time formart to use
    utc_now = NaiveDateTime.utc_now()

    from q in query,
      where: q.expir >= ^utc_now and q.active == true,
      order_by: q.inserted_at
  end

  @doc """
  query to get promocode by title
  """
  def promocode_by_title_query(query, title) do
    from q in query, where: (q.title == ^title)
  end

  @doc """
  This query will check if the provided promocode is within the given radius
  > Pass data of the event
  > This will return all promo codes within the event

  eg. Since this feature is not requested this function is an extra
      This query requires the **POSTGIS** extention
  """
  def within_event_radius(query, point, radius_in_m) do
    {lng, lat} = point.coordinates

    from promo in query,
      where:
        fragment(
          "ST_DWithin(?::geography, ST_SetSRID(ST_MakePoint(?, ?), ?), ?)",
          promo.point,
          ^lng,
          ^lat,
          ^point.srid,
          ^radius_in_m
        )
  end

  @doc """
    This will fetch all active promocodes within a give radius
  """
  def get_active_promocodes_within(center_point, radius_in_m) do
    Promocode
    |> within_event_radius(center_point, radius_in_m)
    |> active_promo_query()
    |> Repo.all()
  end

  @doc """
  This function will take the Promocode struct and source point and then check if they are within the radius.
  """
  def location_within_event(%Promocode{} = promocode, %Geo.Point{} = source_point) do
    %Geo.Point{coordinates: {lgt, lat}} = promocode.point
    {d_lgt, d_lat} = source_point.coordinates

    center = [lat, lgt]
    d_p_point = [d_lat, d_lgt]

    if Geocalc.within?(promocode.distance, center, d_p_point) do
      {:ok, promocode}
    else
      {:bound_error, "You can't use this promocode here"}
    end
  end
end
