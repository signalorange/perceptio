defmodule Perceptio.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PerceptioWeb.Telemetry,
      Perceptio.Repo,
      {DNSCluster, query: Application.get_env(:perceptio, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Perceptio.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Perceptio.Finch},
      Perceptio.DataStore,
      # Start a worker by calling: Perceptio.Worker.start_link(arg)
      # {Perceptio.Worker, arg},
      # Start to serve requests, typically the last entry
      PerceptioWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Perceptio.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PerceptioWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
