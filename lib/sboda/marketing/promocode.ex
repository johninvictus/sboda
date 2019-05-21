defmodule Sboda.Marketing.Promocode do
  @moduledoc """
  This module takes will take raw input
    |> validate them 
    |> convert the to required format

    Giving this module validation power will reduce amount of code writed at the Web Module
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Sboda.Money

  @type_currency_include ~w(KES UGX)

  schema "promocodes" do
    field :title, :string
    # where the event is located
    field :point, Geo.PostGIS.Geometry
    field :active, :boolean
    field :expir, :naive_datetime
    field :worth, Money.Ecto
    field :distance, :float

    # virtual fields to receive raw params
    # will be converted to points
    field :lat, :float, virtual: true
    field :logt, :float, virtual: true
    # expir virtual field
    field :expir_str, :string, virtual: true
    # worth string()
    # formart should be 0.00 KSH
    field :worth_str, :string, virtual: true
    # Include currency (either KES or UGX)
    field :currency, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(promocode, attrs) do
    promocode
    |> cast(attrs, [:title, :lat, :logt, :expir_str, :worth_str, :active, :distance, :currency])
    # exclude active since it has a default value
    |> validate_required([
      :title,
      :lat,
      :logt,
      :expir_str,
      :worth_str,
      :active,
      :distance,
      :currency
    ])
    # make sure either KES or UGX is included
    |> validate_inclusion(:currency, @type_currency_include)
    # should be 0.00
    |> validate_format(:worth_str, ~r/\A\d+\.\d{2}\Z/, message: "money format is invalid")
    |> create_point()
    |> create_naive_date()
    |> create_money()
  end

  # This functions takes in latitude and longitude and converts them into a Geo.Point
  defp create_point(changeset) do
    if(changeset.valid?) do
      data = changeset |> apply_changes()
      # the first value is logitude the other is latitude
      changeset
      |> put_change(:point, %Geo.Point{coordinates: {data.logt, data.lat}, srid: 4326})
    else
      changeset
    end
  end

  # This function convert a valid date string to Naive date which is easier to work with.
  defp create_naive_date(changeset) do
    if(changeset.valid?) do
      data = changeset |> apply_changes()

      case NaiveDateTime.from_iso8601(data.expir_str) do
        {:ok, naive} ->
          changeset |> put_change(:expir, naive)

        {:error, :invalid_format} ->
          changeset
      end
    else
      changeset
    end
  end

  # This function converts currency and money string to money struct
  defp create_money(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true} ->
        data = changeset |> apply_changes()
        m_ob = Money.new("#{data.worth_str} " <> "#{data.currency}")
        put_change(changeset, :worth_str, m_ob)

      %Ecto.Changeset{valid?: false} ->
        changeset
    end
  end
end
