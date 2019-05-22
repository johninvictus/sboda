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
  def get_all_promocodes do
    Promocode |> Repo.all()
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
  """
  def within_event_radius(query, point, radius_in_m, promo_title) do
    {lng, lat} = point.coordinates

    from promo in query,
      where:
        promo.title == ^promo_title and
          fragment(
            "ST_DWithin(?::geography, ST_SetSRID(ST_MakePoint(?, ?), ?), ?)",
            promo.point,
            ^lng,
            ^lat,
            ^point.srid,
            ^radius_in_m
          )
  end
end
