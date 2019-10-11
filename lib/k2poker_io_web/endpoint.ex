defmodule K2pokerIoWeb.Endpoint do

  use Phoenix.Endpoint, otp_app: :k2poker_io

  socket "/socket", K2pokerIoWeb.UserSocket,
    websocket: true,
    longpoll: false

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phoenix.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/", from: :k2poker_io, gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug Plug.MethodOverride
  plug Plug.Head

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  plug Plug.Session,
    store: :cookie,
    max_age: 24*60*60*365,
    key: "_k2poker_io_key",
    signing_salt: "xNvzuKCbJGcPjBo69D4M3#6UCXmrUG#?2ZM43G7tuU9yPD,r$E"

  plug K2pokerIoWeb.Router
end
