defmodule MarineApp.MarineAppWeb.PositionReport do
  use Ecto.Schema
  import Ecto.Changeset

  schema "position_reports" do
    field :timestamp, :utc_datetime
    field :vessel_id, :string
    field :latitude, :float
    field :longitude, :float

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(position_report, attrs) do
    position_report
    |> cast(attrs, [:vessel_id, :timestamp, :latitude, :longitude])
    |> validate_required([:vessel_id, :timestamp, :latitude, :longitude])
  end
end
