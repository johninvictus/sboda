defmodule Sboda.ValidateRequest do
  use Ecto.Schema
  import Ecto.Changeset

  alias Sboda.Marketing
  alias Sboda.Marketing.Promocode

  embedded_schema do
    field :destination_latitude, :float
    field :destination_longitude, :float
    field :origin_latitude, :float
    field :origin_longitude, :float
    field :promocode, :string

    embeds_one(:promo, Promocode)

    field :destination_within, :boolean
    field :origin_within, :boolean

    field :error, :string
  end

  def changeset(struct, params \\ Map.new()) do
    struct
    |> cast(params, [
      :destination_latitude,
      :destination_longitude,
      :origin_latitude,
      :origin_longitude,
      :promocode
    ])
    |> validate_required([
      :destination_latitude,
      :destination_longitude,
      :origin_latitude,
      :origin_longitude,
      :promocode
    ])
    |> set_promo_struct()
    |> destination_location_within()
    |> origin_location_within()
    |> can_use_this_promocode()
  end

  @doc """
  This function will put data to the promo embed if the promocode is available
    else
        put an error to changeset
  """
  def set_promo_struct(changeset) do
    #
    case changeset do
      %Ecto.Changeset{valid?: true} ->
        data = apply_changes(changeset)

        with value when is_map(value) <- Marketing.get_active_promocode_by_title(data.promocode) do
          changeset |> put_embed(:promo, value)
        else
          nil ->
            add_error(changeset, :promocode, "Promocode is not among the active ones")

          _ ->
            add_error(changeset, :promocode, "Promocode error")
        end

      %Ecto.Changeset{valid?: false} ->
        changeset
    end
  end

  def destination_location_within(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true} ->
        data = apply_changes(changeset)
        promocode = data.promo

        dest_point = %Geo.Point{
          coordinates: {data.destination_longitude, data.destination_latitude},
          properties: %{},
          srid: 4326
        }

        case Marketing.location_within_event(promocode, dest_point) do
          {:ok, _promocode} ->
            changeset |> put_change(:destination_within, true)

          {:bound_error, _message} ->
            changeset |> put_change(:destination_within, false)
        end

      %Ecto.Changeset{valid?: false} ->
        changeset
    end
  end

  def origin_location_within(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true} ->
        data = apply_changes(changeset)
        promocode = data.promo

        origin_point = %Geo.Point{
          coordinates: {data.origin_longitude, data.origin_latitude},
          properties: %{},
          srid: 4326
        }

        case Marketing.location_within_event(promocode, origin_point) do
          {:ok, _promocode} ->
            changeset |> put_change(:origin_within, true)

          {:bound_error, _message} ->
            changeset |> put_change(:origin_within, false)
        end

      %Ecto.Changeset{valid?: false} ->
        changeset
    end
  end

  @doc """
   This function checks if destination or pickup point is within the event/promo distance
   Return error if not, else return valid changeset
  """
  def can_use_this_promocode(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true} ->
        data = apply_changes(changeset)

        # check if origin or destination is within the promocode radius
        if(data.destination_within || data.origin_within) do
          changeset
        else
          changeset |> add_error(:error, "This promocode can't be used within this area")
        end
      %Ecto.Changeset{valid?: false} ->
        changeset
    end
  end
end
