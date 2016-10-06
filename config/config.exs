# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :k2poker_io,
  ecto_repos: [K2pokerIo.Repo]

# Configures the endpoint
config :k2poker_io, K2pokerIo.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "PwMUU1X7uIJOIwgxJ19EsBhrYmZK7RaSy7qap8ohnFkpTlU/919kcE5jgoF8OxAb",
  render_errors: [view: K2pokerIo.ErrorView, accepts: ~w(html json)],
  pubsub: [name: K2pokerIo.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
