defmodule Webcrawler.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      WebcrawlerWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Webcrawler.PubSub},
      # Cassandra database
      {Xandra, Application.fetch_env!(:webcrawler, :xandra)},
      # Start the Endpoint (http/https)
      WebcrawlerWeb.Endpoint
      # Start a worker by calling: Webcrawler.Worker.start_link(arg)
      # {Webcrawler.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Webcrawler.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    WebcrawlerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
