defmodule Modbridge.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ModbridgeWeb.Telemetry,
      Modbridge.Repo,
      {DNSCluster, query: Application.get_env(:modbridge, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Modbridge.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Modbridge.Finch},
      # Start a worker by calling: Modbridge.Worker.start_link(arg)
      # {Modbridge.Worker, arg},
      # Start to serve requests, typically the last entry
      ModbridgeWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Modbridge.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ModbridgeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
