defmodule Sboda.MarketingTest do
  use Sboda.DataCase

  alias Sboda.Marketing

  describe "promocodes" do
    alias Sboda.Marketing.Promocode

    @valid_attrs %{title: "some title"}
    @update_attrs %{title: "some updated title"}
    @invalid_attrs %{title: nil}

    def promocode_fixture(attrs \\ %{}) do
      {:ok, promocode} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Marketing.create_promocode()

      promocode
    end

    test "list_promocodes/0 returns all promocodes" do
      promocode = promocode_fixture()
      assert Marketing.list_promocodes() == [promocode]
    end

    test "get_promocode!/1 returns the promocode with given id" do
      promocode = promocode_fixture()
      assert Marketing.get_promocode!(promocode.id) == promocode
    end

    test "create_promocode/1 with valid data creates a promocode" do
      assert {:ok, %Promocode{} = promocode} = Marketing.create_promocode(@valid_attrs)
      assert promocode.title == "some title"
    end

    test "create_promocode/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Marketing.create_promocode(@invalid_attrs)
    end

    test "update_promocode/2 with valid data updates the promocode" do
      promocode = promocode_fixture()
      assert {:ok, %Promocode{} = promocode} = Marketing.update_promocode(promocode, @update_attrs)
      assert promocode.title == "some updated title"
    end

    test "update_promocode/2 with invalid data returns error changeset" do
      promocode = promocode_fixture()
      assert {:error, %Ecto.Changeset{}} = Marketing.update_promocode(promocode, @invalid_attrs)
      assert promocode == Marketing.get_promocode!(promocode.id)
    end

    test "delete_promocode/1 deletes the promocode" do
      promocode = promocode_fixture()
      assert {:ok, %Promocode{}} = Marketing.delete_promocode(promocode)
      assert_raise Ecto.NoResultsError, fn -> Marketing.get_promocode!(promocode.id) end
    end

    test "change_promocode/1 returns a promocode changeset" do
      promocode = promocode_fixture()
      assert %Ecto.Changeset{} = Marketing.change_promocode(promocode)
    end
  end
end
