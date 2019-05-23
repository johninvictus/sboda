defmodule Sboda.RideTest do
  use Sboda.DataCase

  describe "Ride module test" do
    alias Sboda.Marketing
    alias Sboda.Marketing.Promocode
    alias Sboda.Ride

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

    test "request" do
      param = %{
        "destination" => %{"latitude" => 43.0387105, "longitude" => -87.9074701},
        "origin" => %{"latitude" => 43.0372896, "longitude" => -87.9082446},
        "promocode" => "SAFE_BODA_EVENT"
      }

      promocode_fixture()

      # check if correct params are giving correct results
      assert {:ok, %Promocode{}, _polyline_string, _} = Ride.request(param)

      param = %{
        "destination" => %{"latitude" => 433.0387105, "longitude" => -87.9074701},
        "origin" => %{"latitude" => 37.772, "longitude" => -87.9082446},
        "promocode" => "SAFE_BODA_EVENT"
      }

      # when origin and dest are not near
      assert {:changeset_error, %Ecto.Changeset{valid?: false}} = Ride.request(param)

      param = %{
        "destination" => %{"latitude" => 43.0387105, "longitude" => -87.9074701},
        "origin" => %{"latitude" => 37.772, "longitude" => -87.9082446},
        "promocode" => "SAFE_BODA_EVENT"
      }

      # if destination is within
      assert {:ok, %Promocode{}, _polyline_string, _} = Ride.request(param)

      # if lat are not okay
      param = %{
        "destination" => %{"latitude" => 43.0387105, "longitude" => -87.9074701},
        "origin" => %{"latitude" => 43.0372896, "longitude" => "-87.9082446x"},
        "promocode" => "SAFE_BODA_EVENT"
      }

      # invalid type
      assert {:changeset_error, %Ecto.Changeset{valid?: false}} =  Ride.request(param)
    end
  end
end
