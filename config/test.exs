use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :k2poker_io, K2pokerIoWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :k2poker_io, K2pokerIo.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "stuart",
  password: "aurora1",
  database: "k2poker_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  ownership_timeout: 60_000
