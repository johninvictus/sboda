defmodule Sboda.DirectionApi do
  @moduledoc """
  This module is responsible for fetching the polyline of destination and origin
  """
  @base_url "https://maps.googleapis.com/maps/api/directions/json"

  def get_polyline(origin, destination) do
    params = %{
      origin: origin,
      destination: destination,
      key: get_api_key()
    }

    @base_url
    |> HTTPoison.get([], params: params)
    |> decode_response()
  end

  @doc """
  extract the polyline string and encode the polystring
  iex> decode_response(origin, destination)
  {:ok, "}~teGtlpwOBbArFYH`CXA",
  [
  {-87.90747, 43.03871},
  ...
  ]}

  iex> decode_response(origin_wrong, destination_wrong)
  :error
  """
  @spec decode_response({:ok, %HTTPoison.Response{}}) :: {:ok, String.t(), list()} | atom()
  def decode_response({:ok, %HTTPoison.Response{body: body, status_code: 200}}) do
    case JSON.decode(body) do
      {:ok, json_map} ->
        status = json_map |> get_in(["status"])

        if(status == "NOT_FOUND" || status == "ZERO_RESULTS") do
          :error
        else
          polyline_string =
            json_map
            |> get_in(["routes"])
            |> Enum.at(0)
            |> get_in(["overview_polyline", "points"])

          {:ok, polyline_string, Polyline.decode(polyline_string)}
        end

      _ ->
        :error
    end
  end

  def decode_response(_), do: :error

  defp get_api_key do
    "AIzaSyApv62DXUcXNxDTyj5U9o9mnfOQ5Zyr7ck"
  end
end
