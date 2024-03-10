defmodule MarineAppWeb.PositionReportJSON do
  alias MarineApp.MarineAppWeb.PositionReport

  @doc """
  Renders a list of position_reports.
  """
  def index(%{position_reports: position_reports}) do
    %{data: for(position_report <- position_reports, do: data(position_report))}
  end

  @doc """
  Renders a single position_report.
  """
  def show(%{position_report: position_report}) do
    %{data: data(position_report)}
  end

  defp data(%PositionReport{} = position_report) do
    %{
      id: position_report.id,
      vessel_id: position_report.vessel_id,
      timestamp: position_report.timestamp,
      latitude: position_report.latitude,
      longitude: position_report.longitude
    }
  end
end
