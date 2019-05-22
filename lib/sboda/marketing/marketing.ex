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
  Is destination or pickup location within the radius
  > Provide the promocode name
  > check if it exist first

  ## EXAMPLE

  If promocode is not found in the database
  iex> location_within("Invalid point", %Geo.Point{})
    {:errorloc, "Invalid promocode"}

  iex> location_within("valid_title", %Geo.Point{})
   {:ok, %Sboda.Marketing.Promocode{}}

  iex> location_within("valid_title", %Geo.Point{} = far_point)
     {:bound_error, "given point cant use the promocode"}
  """
  def location_within(promo_title, %Geo.Point{} = source_point) do
    case get_promocode_by_title(promo_title) do
      nil ->
        {:errorloc, "Promocode not found"}

      promo ->
        %Geo.Point{
          coordinates: {lgt, lat},
          properties: %{},
          srid: 4326
        } = promo.point

        {d_lgt, d_lat} = source_point.coordinates

        center = [lat, lgt]
        d_p_point = [d_lat, d_lgt]

        if Geocalc.within?(promo.distance, center, d_p_point) do
          {:ok, promo}
        else
          {:bound_error, "given point cant use the promocode"}
        end
    end
  end
end
