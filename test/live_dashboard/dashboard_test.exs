defmodule LiveDashboard.DashboardTest do
  use LiveDashboard.DataCase

  alias LiveDashboard.Dashboard

  describe "indicators" do
    alias LiveDashboard.Dashboard.Indicator

    import LiveDashboard.DashboardFixtures

    @invalid_attrs %{description: nil}

    test "list_indicators/0 returns all indicators" do
      indicator = indicator_fixture()
      assert Dashboard.list_indicators() == [indicator]
    end

    test "get_indicator!/1 returns the indicator with given id" do
      indicator = indicator_fixture()
      assert Dashboard.get_indicator!(indicator.id) == indicator
    end

    test "create_indicator/1 with valid data creates a indicator" do
      valid_attrs = %{description: "some description"}

      assert {:ok, %Indicator{} = indicator} = Dashboard.create_indicator(valid_attrs)
      assert indicator.description == "some description"
    end

    test "create_indicator/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Dashboard.create_indicator(@invalid_attrs)
    end

    test "update_indicator/2 with valid data updates the indicator" do
      indicator = indicator_fixture()
      update_attrs = %{description: "some updated description"}

      assert {:ok, %Indicator{} = indicator} = Dashboard.update_indicator(indicator, update_attrs)
      assert indicator.description == "some updated description"
    end

    test "update_indicator/2 with invalid data returns error changeset" do
      indicator = indicator_fixture()
      assert {:error, %Ecto.Changeset{}} = Dashboard.update_indicator(indicator, @invalid_attrs)
      assert indicator == Dashboard.get_indicator!(indicator.id)
    end

    test "delete_indicator/1 deletes the indicator" do
      indicator = indicator_fixture()
      assert {:ok, %Indicator{}} = Dashboard.delete_indicator(indicator)
      assert_raise Ecto.NoResultsError, fn -> Dashboard.get_indicator!(indicator.id) end
    end

    test "change_indicator/1 returns a indicator changeset" do
      indicator = indicator_fixture()
      assert %Ecto.Changeset{} = Dashboard.change_indicator(indicator)
    end
  end
end
