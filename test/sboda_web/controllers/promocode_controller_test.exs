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

    assert %HTTPoison.Response{body: body, status_code: 200} =   HTTPoison.get!(APICall.api_url() <> "/promocodes")
    promo_map = JSON.decode!(body) |> get_in(["data"]) |> Enum.at(0)
    assert get_in(promo_map, ["title"]) == @data_attrs.title
  end
end
