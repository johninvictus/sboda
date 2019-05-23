defmodule Sboda.MarketingTest do
  use Sboda.DataCase

  alias Sboda.Marketing

  describe "promocodes" do
    alias Sboda.Marketing.Promocode
    alias Sboda.Money

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

    def promocode_fixture(attr \\ Map.new()) do
      {:ok, promo} =
        attr
        |> Enum.into(@data_attrs)
        |> Marketing.create_promocode()

      promo
    end

    def multiple_promocodes_fixture do
      # promocodes to test expire date and active = true
      # four possible scenarios
      data_test = [
        %{
          title: "SAFE_BODA_EVENT_1",
          lat: 43.0387105,
          logt: -87.9074701,
          expir_str: "2029-07-01 23:00:07",
          worth_str: "250.00",
          distance: 400.3,
          currency: "KES",
          active: true
        },
        %{
          title: "SAFE_BODA_EVENT_2",
          lat: 43.0372896,
          logt: -87.9082446,
          expir_str: "2019-07-01 23:00:07",
          worth_str: "250.00",
          distance: 400.3,
          currency: "KES",
          active: false
        },
        %{
          title: "SAFE_BODA_EVENT_3",
          lat: 43.035253,
          logt: -87.9091676,
          expir_str: "2018-07-01 23:00:07",
          worth_str: "250.00",
          distance: 400.3,
          currency: "KES",
          active: false
        },
        %{
          title: "SAFE_BODA_EVENT_4",
          lat: 43.0020021,
          logt: -87.9033059,
          expir_str: "2018-07-01 23:00:07",
          worth_str: "250.00",
          distance: 400.3,
          currency: "KES",
          active: true
        }
      ]

      Enum.each(data_test, fn params ->
        params |> Marketing.create_promocode()
      end)
    end

    def to_test_promocodes_around_fixture do
      data_test = [
        %{
          title: "SAFE_BODA_EVENT_1",
          lat: 43.0387105,
          logt: -87.9074701,
          expir_str: "2029-07-01 23:00:07",
          worth_str: "250.00",
          distance: 400.3,
          currency: "KES",
          active: true
        },
        %{
          title: "SAFE_BODA_EVENT_2",
          lat: 43.0372896,
          logt: -87.9082446,
          expir_str: "2029-07-01 23:00:07",
          worth_str: "250.00",
          distance: 400.3,
          currency: "KES",
          active: false
        },
        %{
          title: "SAFE_BODA_EVENT_3",
          lat: 43.035253,
          logt: -87.9091676,
          expir_str: "2019-07-01 23:00:07",
          worth_str: "250.00",
          distance: 400.3,
          currency: "KES",
          active: false
        },
        %{
          title: "SAFE_BODA_EVENT_4",
          lat: 43.0020021,
          logt: -87.9033059,
          expir_str: "2018-07-01 23:00:07",
          worth_str: "250.00",
          distance: 400.3,
          currency: "KES",
          active: true
        }
      ]

      Enum.each(data_test, fn params ->
        params |> Marketing.create_promocode()
      end)
    end

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
        worth: %Money{cents: 25000, currency: "KES"},
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

  test "list all promocodes" do
    # null the virtual fields, for test purposes
    promocodes = %{
      promocode_fixture()
      | currency: nil,
        expir_str: nil,
        lat: nil,
        logt: nil,
        worth_str: nil
    }

    assert Marketing.get_all_promocodes() == [promocodes]
  end

  test "get_active_promocodes" do
    multiple_promocodes_fixture()

    assert [%Sboda.Marketing.Promocode{} = promo] = Marketing.get_active_promocodes()
    assert promo.title == "SAFE_BODA_EVENT_1"
  end

  test "update_promocode" do
    promocode = promocode_fixture()

    assert {:ok, %Sboda.Marketing.Promocode{} = code} =
             Marketing.update_promocode(promocode, %{title: "SAFE_BODA_EVENT_1"})

    assert code.title == "SAFE_BODA_EVENT_1"
  end

  test "within_source_radius" do
    point = %Geo.Point{coordinates: {-87.9079503, 43.0384303}, srid: 4326}
    to_test_promocodes_around_fixture()

    assert [%Sboda.Marketing.Promocode{} = promo] =
             Marketing.get_active_promocodes_within(point, 400)

    assert promo.title == "SAFE_BODA_EVENT_1"
  end
end
