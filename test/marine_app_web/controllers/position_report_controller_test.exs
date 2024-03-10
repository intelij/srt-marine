defmodule MarineAppWeb.PositionReportControllerTest do
  use MarineAppWeb.ConnCase

  import MarineApp.MarineAppWebFixtures

  alias MarineApp.MarineAppWeb.PositionReport

  @create_attrs %{
    timestamp: ~U[2024-03-09 18:45:00Z],
    vessel_id: "some vessel_id",
    latitude: 120.5,
    longitude: 120.5
  }
  @update_attrs %{
    timestamp: ~U[2024-03-10 18:45:00Z],
    vessel_id: "some updated vessel_id",
    latitude: 456.7,
    longitude: 456.7
  }
  @invalid_attrs %{timestamp: nil, vessel_id: nil, latitude: nil, longitude: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all position_reports", %{conn: conn} do
      conn = get(conn, ~p"/api/position_reports")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create position_report" do
    test "renders position_report when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/position_reports", position_report: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/position_reports/#{id}")

      assert %{
               "id" => ^id,
               "latitude" => 120.5,
               "longitude" => 120.5,
               "timestamp" => "2024-03-09T18:45:00Z",
               "vessel_id" => "some vessel_id"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/position_reports", position_report: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update position_report" do
    setup [:create_position_report]

    test "renders position_report when data is valid", %{conn: conn, position_report: %PositionReport{id: id} = position_report} do
      conn = put(conn, ~p"/api/position_reports/#{position_report}", position_report: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/position_reports/#{id}")

      assert %{
               "id" => ^id,
               "latitude" => 456.7,
               "longitude" => 456.7,
               "timestamp" => "2024-03-10T18:45:00Z",
               "vessel_id" => "some updated vessel_id"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, position_report: position_report} do
      conn = put(conn, ~p"/api/position_reports/#{position_report}", position_report: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete position_report" do
    setup [:create_position_report]

    test "deletes chosen position_report", %{conn: conn, position_report: position_report} do
      conn = delete(conn, ~p"/api/position_reports/#{position_report}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/position_reports/#{position_report}")
      end
    end
  end

  defp create_position_report(_) do
    position_report = position_report_fixture()
    %{position_report: position_report}
  end
end
