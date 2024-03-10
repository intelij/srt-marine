defmodule MarineApp.AISReceiver do
  use GenServer
  require Logger

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init([]) do
    :ok = retry_receive()
    {:ok, %{}}
  end

  defp retry_receive() do
    :backoff.run(fn ->
      {:ok, _} = Gun.open("https://api.datalastic.com/api/v0/vessel?api-key={YOUR_API_KEY}&uuid=b8625b67-7142-cfd1-7b85-595cebfe4191") # Replace
      receive_data()
    end)
  end

  defp parse(data) do
    [message_type | fields] = String.split(data, ",")

    case message_type do
      "AIS" ->
        vessel_id = List.first(fields)
        timestamp = List.first(List.drop(fields, 1))
        latitude = List.first(List.drop(fields, 2))
        longitude = List.first(List.drop(fields, 3))
        {:ok, %{vessel_id: vessel_id, timestamp: timestamp, latitude: latitude, longitude: longitude}}
      _ ->
        {:error, "Unsupported AIS message type"}
    end
  end

  defp receive_data() do
    receive do
      {:gun_response, _conn, %{status: status}, data} when status in [200] ->
        handle_data(data)
        receive_data()
      {:gun_response, _conn, %{status: status}, _data} ->
        Logger.error("Failed to receive AIS data. HTTP status: #{status}")
        retry_receive()
      {:gun_error, _conn, reason} ->
        Logger.error("Failed to receive AIS data: #{reason}")
        retry_receive()
    end
  end

  defp handle_data(data) do
    # Logger.info("Received AIS data: #{inspect data}")
    case AISParser.parse(data) do
      {:ok, %{vessel_id: vessel_id, timestamp: timestamp, latitude: latitude, longitude: longitude}} ->
        MarineApp.PositionReport.create_position_report(%{
          vessel_id: vessel_id,
          timestamp: DateTime.from_iso8601!(timestamp),
          latitude: String.to_float(latitude),
          longitude: String.to_float(longitude)
        })
      {:error, reason} ->
        Logger.error("Failed to parse AIS data: #{reason}")
    end
end

end
