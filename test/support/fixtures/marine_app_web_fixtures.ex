defmodule MarineApp.MarineAppWebFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `MarineApp.MarineAppWeb` context.
  """

  @doc """
  Generate a position_report.
  """
  def position_report_fixture(attrs \\ %{}) do
    {:ok, position_report} =
      attrs
      |> Enum.into(%{
        latitude: 120.5,
        longitude: 120.5,
        timestamp: ~U[2024-03-09 18:45:00Z],
        vessel_id: "some vessel_id"
      })
      |> MarineApp.MarineAppWeb.create_position_report()

    position_report
  end
end
