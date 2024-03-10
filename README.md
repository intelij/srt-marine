# MarineApp Data Stream Assessment

Created a Phoenix web application (MarineApp) that provides an API for accessing consolidated AIS data reports. The application is configured with an Ecto Repo module, implements HTTP data reception using gun, and follows Elixir best practices.

### Run Migrations
#### Run migrations to create the necessary database tables:

`
mix ecto.setup
`

#### Start the Phoenix server:

`
mix phx.server
`

#### Verify API Endpoint
`
curl http://localhost:4000/api/position_reports
`


#### Created the GenServer for HTTP Data Receiver
##### Created the module for handling HTTP data reception in lib/srt_marine_app/ais_receiver.ex:

```
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


```

Adhered to Elixir's best practices by using pattern matching, immutability, and OTP principles. Provided a Phoenix web application that serves an API for accessing consolidated AIS data reports, with built-in exponential backoff and retry logic to handle service outages gracefully. Additionally, it's optimized for performance using concurrency and OTP principles.


To enhance security and efficiency in the MarineApp, I could have introduced a few improvements such as implementing CSRF protection, setting up CORS policies, utilizing Elixir's OTP principles for concurrency, and leveraging Phoenix's built-in security features. Additionally, there is room for improvement to ensure proper error handling and logging for better reliability.


### SRT MarineApp folder structure

```
marine_app
├── config
│   └── config.exs
├── lib
│   ├── marine_app
│   │   ├── application.ex
│   │   ├── ais_receiver.ex
│   │   ├── position_report.ex
│   │   └── repo.ex
│   └── marine_app_web
│       ├── channels
│       │   └── ...
│       ├── controllers
│       │   ├── page_controller.ex
│       │   └── position_report_controller.ex
│       ├── templates
│       │   ├── layout
│       │   │   ├── app.html.eex
│       │   │   └── root.html.eex
│       │   └── page
│       │       └── index.html.eex
│       ├── views
│       │   ├── error_helpers.ex
│       │   ├── error_view.ex
│       │   ├── layout_view.ex
│       │   └── page_view.ex
│       ├── app.ex
│       ├── endpoint.ex
│       ├── router.ex
│       └── user_socket.ex
├── priv
│   └── repo
├── test
│   ├── marine_app_web
│   │   ├── controllers
│   │   │   ├── page_controller_test.exs
│   │   │   └── position_report_controller_test.exs
│   │   ├── views
│   │   │   ├── error_view_test.exs
│   │   │   └── page_view_test.exs
│   │   └── marine_app_web_test.exs
│   └── marine_app
│       └── position_report_test.exs
├── assets
│   ├── css
│   │   └── ...
│   ├── js
│   │   └── ...
│   └── static
│       ├── css
│       │   └── ...
│       ├── fonts
│       │   └── ...
│       └── images
│           └── ...
├── .formatter.exs
├── .gitignore
├── README.md
├── mix.exs
└── test_helper.exs
```


### To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`


Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
