defmodule Sboda.Ride do
  @moduledoc """
  This module will deal with everything about rides
  """

  alias Sboda.ValidateRequest

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
      #
    else
      {:changeset_error, changeset}
    end
  end

  def request(_) do
    {:param_error, "Params provided don't have correct fomart"}
  end
end
