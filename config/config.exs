# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Specify the env so i can pick it up in the app
config :k2poker_io, env: Mix.env

# General application configuration
config :k2poker_io,
  ecto_repos: [K2pokerIo.Repo]

# I18n translations (gettext) locale configuration
config :k2poker_io, K2pokerIoWeb, default_locale: "en", locales: ~w(en es)

# Configures the endpoint
config :k2poker_io, K2pokerIoWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "PwMUU1X7uIJOIwgxJ19EsBhrYmZK7RaSy7qap8ohnFkpTlU/919kcE5jgoF8OxAb",
  render_errors: [view: K2pokerIoWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: K2pokerIo.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

#Kerosene (pagination)
config :kerosene,
  mode: :simple

#Configure Mailer
config :k2poker_io, K2pokerIoWeb.Mailer,
  adapter: Bamboo.SendGridAdapter,
  api_key: "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"
