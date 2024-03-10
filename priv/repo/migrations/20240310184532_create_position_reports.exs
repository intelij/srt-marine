defmodule MarineApp.Repo.Migrations.CreatePositionReports do
  use Ecto.Migration

  def change do
    create table(:position_reports) do
      add :vessel_id, :string
      add :timestamp, :utc_datetime
      add :latitude, :float
      add :longitude, :float

      timestamps(type: :utc_datetime)
    end
  end
end
