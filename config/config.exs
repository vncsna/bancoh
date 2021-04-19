# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :bancoh,
  ecto_repos: [Bancoh.Repo]

# Configures the endpoint
config :bancoh, BancohWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "wfht0pMwCVU8u20cZC53i3g2C2+1kIpoMHBgbyGWYiLEMYx9+AAbNTuAaJkEPlr+",
  render_errors: [view: BancohWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Bancoh.PubSub,
  live_view: [signing_salt: "uayMRucS"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
