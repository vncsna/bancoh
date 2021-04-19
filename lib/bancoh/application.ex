defmodule Bancoh.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Bancoh.Repo,
      # Start the Telemetry supervisor
      BancohWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Bancoh.PubSub},
      # Start the Endpoint (http/https)
      BancohWeb.Endpoint
      # Start a worker by calling: Bancoh.Worker.start_link(arg)
      # {Bancoh.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Bancoh.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    BancohWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
