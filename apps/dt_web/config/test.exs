use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :dt_web, DtWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :debug

# Configure your database
config :dt_web, DtWeb.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "dt_web_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
