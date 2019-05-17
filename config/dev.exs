use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :k2poker_io, K2pokerIoWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [node: ["node_modules/brunch/bin/brunch", "watch", "--stdin",
                    cd: Path.expand("../assets", __DIR__)]]

# Recaptcha (localhost)

config :recaptcha,
  public_key: "6LcQqngUAAAAAKxVs7jMdo7zAnGuxQZxOS2MR_LT",
  secret: "6LcQqngUAAAAAIbjwUXnbgy0l7Ol1g617KFbhLrb"

# Watch static and templates for browser reloading.
config :k2poker_io, K2pokerIoWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{lib/k2poker_io_web/views/.*(ex)$},
      ~r{lib/k2poker_io_web/templates/.*(eex)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Configure your database
config :k2poker_io, K2pokerIo.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "stuart",
  password: "aurora1",
  database: "k2poker_dev",
  hostname: "localhost",
  pool_size: 10

config :facebook,
  app_id:  "345335705821290",
  app_secret: "4de9e4d3e9bce6ca3efeeef7b43e21ea",
  app_access_token: "345335705821290|OJ_1Q1LYNCCowwZmVcw4adiUI1w",
  graph_url: "https://graph.facebook.com",
  graph_video_url: "https://graph-video.facebook.com"

