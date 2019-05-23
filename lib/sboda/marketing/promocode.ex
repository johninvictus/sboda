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
  alias Sboda.Marketing.Promocode
  alias Sboda.Gex

  @type_currency_include ~w(KES UGX)

  schema "promocodes" do
    field :title, :string
    # where the event is located
    field :point, Gex.Ecto
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
      :distance,
      :currency
    ])
    |> unique_constraint(:title)
    # make sure either KES or UGX is included
    |> validate_inclusion(:currency, @type_currency_include)
    # should be 0.00
    |> validate_format(:worth_str, ~r/\A\d+\.\d{2}\Z/, message: "money format is invalid")
    |> create_point()
    |> create_naive_date()
    |> create_money()
  end

  @doc """
  Create changet to enable update

  Use this changeset to update stuff
  """
  def update_changeset(promocode, attrs) do
    promocode
    |> prepare_promocode()
    |> changeset(attrs)
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
        put_change(changeset, :worth, m_ob)

      %Ecto.Changeset{valid?: false} ->
        changeset
    end
  end

  # Prepare promocode struct for update by adding virtual fields to prevent required error
  defp prepare_promocode(%Promocode{} = promocode) do
    %Promocode{
      expir: exp,
      point: %Geo.Point{coordinates: {log, lat}, properties: %{}, srid: 4326},
      worth: pesa
    } = promocode

    # get money string
    w_str =
      pesa
      |> Sboda.Money.to_string()
      |> String.split(" ")
      |> Enum.at(0)

    %{
      promocode
      | expir_str: NaiveDateTime.to_string(exp),
        lat: lat,
        logt: log,
        currency: pesa.currency,
        worth_str: w_str
    }
  end
end
