# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :dt_web, DtWeb.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "8usHTvLjCzv3Qm+xXkKfqXnxosWMTbu6idGkv7xYRXMtBmu7SJDBfj5OZjGVGtur",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: DtWeb.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: false

# config :joken, config_module: Guardian.JWT

config :guardian, Guardian, 
  issuer: "DtWeb",
  ttl: {1, :days},
  verify_issuer: true,
  secret_key: "changemeabsolutelyyaddayadda",
  serializer: DtWeb.GuardianSerializer
