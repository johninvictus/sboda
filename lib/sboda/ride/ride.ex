defmodule Sboda.Ride do
  @moduledoc """
  This module will deal with everything about rides
  """

  alias Sboda.Ride.ValidateRequest
  import Ecto.Changeset
  alias Sboda.DirectionApi

  @doc """
  This function will be provided with params which are
     > Origin
     > destination
     > promocode # no required
  """
  def request(%{
        "destination" => %{
          "latitude" => destination_latitude,
          "longitude" => destination_longitude
        },
        "origin" => %{"latitude" => origin_latitude, "longitude" => origin_longitude},
        "promocode" => promocode
      }) do
    param = %{
      destination_latitude: destination_latitude,
      destination_longitude: destination_longitude,
      origin_latitude: origin_latitude,
      origin_longitude: origin_longitude,
      promocode: promocode
    }

    changeset = ValidateRequest.changeset(%ValidateRequest{}, param)

    if(changeset.valid?) do
      data = changeset |> apply_changes()

      origin = "#{origin_latitude},#{origin_longitude}"
      destination = "#{destination_latitude},#{destination_longitude}"

      case(DirectionApi.get_polyline(origin, destination)) do
        {:ok, polyline_string, decoded_polyline} ->
          {:ok, data.promo, polyline_string, decoded_polyline}

        :error ->
          {:error, "An error occurred while fetching the polylines, try again"}
      end
    else
      {:changeset_error, changeset}
    end
  end

  def request(_) do
    {:error, "Params provided don't have correct fomart"}
  end
end
