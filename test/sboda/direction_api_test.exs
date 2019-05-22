defmodule Sboda.DirectionApiTest do
  use Sboda.DataCase
  alias Sboda.DirectionApi

  describe "DirectionApi" do
    test "get_polyline" do
      origin = "43.0387105,-87.9074701"
      dest = "43.0372896,-87.9082446"

      assert {:ok, _, _} = DirectionApi.get_polyline(origin, dest)

      dest = "43.0372896,-87.9082446Z"
      assert :error == DirectionApi.get_polyline(origin, dest)
    end
  end
end
