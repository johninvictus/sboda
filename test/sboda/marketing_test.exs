defmodule Sboda.MarketingTest do
  use Sboda.DataCase

  alias Sboda.Marketing

  describe "promocodes" do
    alias Sboda.Marketing.Promocode

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

    test "check if promocode changeset is generating the desired struct" do
      expected_p_data = %{
        currency: "KES",
        distance: 400.3,
        expir: ~N[2019-07-01 23:00:07],
        expir_str: "2019-07-01 23:00:07",
        lat: 43.0387105,
        logt: -87.9074701,
        point: %Geo.Point{coordinates: {-87.9074701, 43.0387105}, properties: %{}, srid: 4326},
        title: "SAFE_BODA_EVENT",
        worth_str: "250.00",
        worth: %Sboda.Money{cents: 25000, currency: "KES"},
        active: true
      }

      %Ecto.Changeset{changes: changes} = Promocode.changeset(%Promocode{}, @data_attrs)

      assert changes == expected_p_data
    end
  end

  test "create_promocode/1 with valid data creates a promocode" do
    assert {:ok, %Sboda.Marketing.Promocode{} = promo} = Marketing.create_promocode(@data_attrs)
    assert promo.title == @data_attrs.title
  end
end
