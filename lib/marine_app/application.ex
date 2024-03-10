defmodule MarineApp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      MarineAppWeb.Telemetry,
      MarineApp.Repo,
      MarineApp.AISReceiver,
      {DNSCluster, query: Application.get_env(:marine_app, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: MarineApp.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: MarineApp.Finch},
      # Start a worker by calling: MarineApp.Worker.start_link(arg)
      # {MarineApp.Worker, arg},
      # Start to serve requests, typically the last entry
      MarineAppWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MarineApp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MarineAppWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
