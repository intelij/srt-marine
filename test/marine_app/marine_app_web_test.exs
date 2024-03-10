defmodule MarineApp.MarineAppWebTest do
  use MarineApp.DataCase

  alias MarineApp.MarineAppWeb

  describe "position_reports" do
    alias MarineApp.MarineAppWeb.PositionReport

    import MarineApp.MarineAppWebFixtures

    @invalid_attrs %{timestamp: nil, vessel_id: nil, latitude: nil, longitude: nil}

    test "list_position_reports/0 returns all position_reports" do
      position_report = position_report_fixture()
      assert MarineAppWeb.list_position_reports() == [position_report]
    end

    test "get_position_report!/1 returns the position_report with given id" do
      position_report = position_report_fixture()
      assert MarineAppWeb.get_position_report!(position_report.id) == position_report
    end

    test "create_position_report/1 with valid data creates a position_report" do
      valid_attrs = %{timestamp: ~U[2024-03-09 18:45:00Z], vessel_id: "some vessel_id", latitude: 120.5, longitude: 120.5}

      assert {:ok, %PositionReport{} = position_report} = MarineAppWeb.create_position_report(valid_attrs)
      assert position_report.timestamp == ~U[2024-03-09 18:45:00Z]
      assert position_report.vessel_id == "some vessel_id"
      assert position_report.latitude == 120.5
      assert position_report.longitude == 120.5
    end

    test "create_position_report/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = MarineAppWeb.create_position_report(@invalid_attrs)
    end

    test "update_position_report/2 with valid data updates the position_report" do
      position_report = position_report_fixture()
      update_attrs = %{timestamp: ~U[2024-03-10 18:45:00Z], vessel_id: "some updated vessel_id", latitude: 456.7, longitude: 456.7}

      assert {:ok, %PositionReport{} = position_report} = MarineAppWeb.update_position_report(position_report, update_attrs)
      assert position_report.timestamp == ~U[2024-03-10 18:45:00Z]
      assert position_report.vessel_id == "some updated vessel_id"
      assert position_report.latitude == 456.7
      assert position_report.longitude == 456.7
    end

    test "update_position_report/2 with invalid data returns error changeset" do
      position_report = position_report_fixture()
      assert {:error, %Ecto.Changeset{}} = MarineAppWeb.update_position_report(position_report, @invalid_attrs)
      assert position_report == MarineAppWeb.get_position_report!(position_report.id)
    end

    test "delete_position_report/1 deletes the position_report" do
      position_report = position_report_fixture()
      assert {:ok, %PositionReport{}} = MarineAppWeb.delete_position_report(position_report)
      assert_raise Ecto.NoResultsError, fn -> MarineAppWeb.get_position_report!(position_report.id) end
    end

    test "change_position_report/1 returns a position_report changeset" do
      position_report = position_report_fixture()
      assert %Ecto.Changeset{} = MarineAppWeb.change_position_report(position_report)
    end
  end
end
