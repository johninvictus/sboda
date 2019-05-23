defmodule SbodaWeb.RideControllerTest do
  use SbodaWeb.ConnCase
  use Sboda.DataCase

  @request_ride_params %{
    origin: %{
      latitude: 43.0387105,
      longitude: -87.9074701
    },
    destination: %{
      latitude: 43.035253,
      longitude: -87.9033059
    },
    promocode: "SAFE_BODA_EVENT"
  }

  @data_attrs %{
    title: "SAFE_BODA_EVENT",
    lat: 43.0387105,
    logt: -87.9074701,
    expir_str: "2019-07-01 23:00:07",
    worth_str: "250.00",
    distance: 400.3,
    currency: "KES",
    active: true
  }

  test "POST ride/request return 201" do
    Sboda.Marketing.create_promocode(@data_attrs)

    headers = [{"Content-type", "application/json"}]

    response =
      HTTPoison.post!(
        APICall.api_url() <> "/ride/request",
        JSON.encode!(@request_ride_params),
        headers,
        []
      )

    assert %HTTPoison.Response{body: body, status_code: 200} = response
    json_map = JSON.decode!(body)

    assert get_in(json_map, ["data", "promocode","title"]) == @data_attrs.title
  end
end
