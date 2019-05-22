defmodule Sboda.Ride.ValidateRequestTest do
  use Sboda.DataCase

  describe "ValidateRequest" do
    alias Sboda.Ride.ValidateRequest
    alias Sboda.Marketing


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

    test "changeset" do
      param = %{
        destination_latitude: 43.0387105,
        destination_longitude: -87.9074701,
        origin_latitude: 43.0372896,
        origin_longitude: -87.9082446,
        promocode: "SAFE_BODA_EVENT"
      }
      promocode_fixture()
      assert %Ecto.Changeset{valid?: true} = ValidateRequest.changeset(%ValidateRequest{}, param)

      param = %{
        destination_latitude: 43.0387105,
        destination_longitude: -87.9074701,
        origin_latitude: 43.0372896,
        origin_longitude: -87.9082446,
        promocode: "SAFE_BODA_EVENTX"
      }
      assert %Ecto.Changeset{valid?: false} = ValidateRequest.changeset(%ValidateRequest{}, param)

      param = %{
        destination_latitude: 434.0387105,
        destination_longitude: -87.9074701,
        origin_latitude: 436.0372896,
        origin_longitude: -87.9082446,
        promocode: "SAFE_BODA_EVENT"
      }

        assert %Ecto.Changeset{valid?: false} = ValidateRequest.changeset(%ValidateRequest{}, param)

    end
  end
end
