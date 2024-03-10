defmodule MarineApp.MarineAppWeb do
  @moduledoc """
  The MarineAppWeb context.
  """

  import Ecto.Query, warn: false
  alias MarineApp.Repo

  alias MarineApp.MarineAppWeb.PositionReport

  @doc """
  Returns the list of position_reports.

  ## Examples

      iex> list_position_reports()
      [%PositionReport{}, ...]

  """
  def list_position_reports do
    Repo.all(PositionReport)
  end

  @doc """
  Gets a single position_report.

  Raises `Ecto.NoResultsError` if the Position report does not exist.

  ## Examples

      iex> get_position_report!(123)
      %PositionReport{}

      iex> get_position_report!(456)
      ** (Ecto.NoResultsError)

  """
  def get_position_report!(id), do: Repo.get!(PositionReport, id)

  @doc """
  Creates a position_report.

  ## Examples

      iex> create_position_report(%{field: value})
      {:ok, %PositionReport{}}

      iex> create_position_report(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_position_report(attrs \\ %{}) do
    %PositionReport{}
    |> PositionReport.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a position_report.

  ## Examples

      iex> update_position_report(position_report, %{field: new_value})
      {:ok, %PositionReport{}}

      iex> update_position_report(position_report, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_position_report(%PositionReport{} = position_report, attrs) do
    position_report
    |> PositionReport.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a position_report.

  ## Examples

      iex> delete_position_report(position_report)
      {:ok, %PositionReport{}}

      iex> delete_position_report(position_report)
      {:error, %Ecto.Changeset{}}

  """
  def delete_position_report(%PositionReport{} = position_report) do
    Repo.delete(position_report)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking position_report changes.

  ## Examples

      iex> change_position_report(position_report)
      %Ecto.Changeset{data: %PositionReport{}}

  """
  def change_position_report(%PositionReport{} = position_report, attrs \\ %{}) do
    PositionReport.changeset(position_report, attrs)
  end
end
