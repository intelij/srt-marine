defmodule MarineAppWeb.PositionReportController do
  use MarineAppWeb, :controller

  alias MarineApp.MarineAppWeb
  alias MarineApp.MarineAppWeb.PositionReport

  action_fallback MarineAppWeb.FallbackController

  # def index(conn, _params) do
  #   position_reports = MarineApp.Repo.all(PositionReport)
  #   render(conn, "index.json", position_reports: position_reports)
  # end

  def index(conn, _params) do
    position_reports = PositionReport.list_position_reports()
    render(conn, "index.json", position_reports: position_reports)
  end

  def create(conn, %{"position_report" => position_report_params}) do
    with {:ok, %PositionReport{} = position_report} <- MarineAppWeb.create_position_report(position_report_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/position_reports/#{position_report}")
      |> render(:show, position_report: position_report)
    end
  end

  def show(conn, %{"id" => id}) do
    position_report = MarineAppWeb.get_position_report!(id)
    render(conn, :show, position_report: position_report)
  end

  def update(conn, %{"id" => id, "position_report" => position_report_params}) do
    position_report = MarineAppWeb.get_position_report!(id)

    with {:ok, %PositionReport{} = position_report} <- MarineAppWeb.update_position_report(position_report, position_report_params) do
      render(conn, :show, position_report: position_report)
    end
  end

  def delete(conn, %{"id" => id}) do
    position_report = MarineAppWeb.get_position_report!(id)

    with {:ok, %PositionReport{}} <- MarineAppWeb.delete_position_report(position_report) do
      send_resp(conn, :no_content, "")
    end
  end
end
