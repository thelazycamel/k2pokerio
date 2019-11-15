defmodule K2pokerIo.Repo do

  use Ecto.Repo,
    otp_app: :k2poker_io,
    adapter: Ecto.Adapters.Postgres

  use Scrivener, page_size: 7

end
