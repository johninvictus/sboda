defmodule SbodaWeb.PromocodeControllerTest do
  use SbodaWeb.ConnCase
  use Sboda.DataCase

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
  def add_data do
    @data_attrs |> Sboda.Marketing.create_promocode()
  end

  test "GET /promocodes" do
    add_data()

    assert %HTTPoison.Response{body: body, status_code: 200} =
             HTTPoison.get!(APICall.api_url() <> "/promocodes")

    promo_map = JSON.decode!(body) |> get_in(["data"]) |> Enum.at(0)
    assert get_in(promo_map, ["title"]) == @data_attrs.title
  end

  test "POST /promocodes" do
    headers = [{"Content-type", "application/json"}]

    response =
      HTTPoison.post!(
        APICall.api_url() <> "/promocodes",
        JSON.encode!(@data_attrs),
        headers,
        []
      )

    assert %HTTPoison.Response{body: body, status_code: 201} = response
  end

  test "GET /promocodes/active" do
    add_data()

    assert %HTTPoison.Response{body: body, status_code: 200} =
             HTTPoison.get!(APICall.api_url() <> "/promocodes/active")

    promo_map = JSON.decode!(body) |> get_in(["data"]) |> Enum.at(0)
    assert get_in(promo_map, ["title"]) == @data_attrs.title
  end

   test "POST /promocodes/config_radius" do
    add_data()

    headers = [{"Content-type", "application/json"}]

    title_param = %{title: "SAFE_BODA_EVENT", radius: 234.0 }

    response =
      HTTPoison.post!(
        APICall.api_url() <> "/promocodes/config_radius",
        JSON.encode!(title_param),
        headers,
        []
      )

    assert %HTTPoison.Response{body: body, status_code: 200} = response
    distance = JSON.decode!(body) |> get_in(["data", "distance"])

    # assert  title_param.distance == distance
    assert title_param.radius == distance
  end
end
