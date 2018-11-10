defmodule K2pokerIo.Mixfile do
  use Mix.Project

  def project do
    [app: :k2poker_io,
     version: "0.6.2",
     elixir: "~> 1.7",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     deps: deps()]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {K2pokerIo, []},
     applications: [:phoenix,
                    :phoenix_pubsub,
                    :phoenix_html,
                    :cowboy,
                    :logger,
                    :gettext,
                    :phoenix_ecto,
                    :postgrex,
                    :k2poker,
                    :gravity,
                    :poison,
                    :phoenix_html_sanitizer,
                    :kerosene,
                    :timex,
                    :comeonin,
                    :bcrypt_elixir,
                    :recaptcha,
                    :edeliver
                    ]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.3.2"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_ecto, "~> 3.3"},
      {:postgrex, ">= 0.0.0"},
      {:poison, "~> 2.0"},
      {:phoenix_html, "~> 2.6"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:gettext, "~> 0.11"},
      {:cowboy, "~> 1.0"},
      {:comeonin, "~> 4.0"},
      {:bcrypt_elixir, "~> 1.0"},
      {:kerosene, "~> 0.8.1"},
      {:k2poker, git: "git@github.com:thelazycamel/k2poker.git", tag: "1.1.0"},
      {:gravity, "~> 1.0.1"},
      {:mix_test_watch, "~> 0.3", only: :dev},
      {:ex_unit_notifier, "~> 0.1", only: :test},
      {:phoenix_html_sanitizer, "~> 1.0.0"},
      {:timex, "~> 3.1"},
      {:edeliver, "~> 1.6.0"},
      {:distillery, "~> 2.0.10"},
      {:recaptcha, "~> 2.3"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     test: [ "ecto.create --quiet", "ecto.migrate", "test"]
     ]
  end
end
