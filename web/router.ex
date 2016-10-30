defmodule K2pokerIo.Router do
  use K2pokerIo.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]

  end

  scope "/", K2pokerIo do
    pipe_through :browser # Use the default browser stack

    resources "/games", GameController, only: [:show]
    post "/games/join", GameController, :join
    post "/anon-user", PageController, :anon_user_create

    resources "/tournaments", TournamentController, only: [:index, :show]

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", K2pokerIo do
  #   pipe_through :api
  # end
end
