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

    post "/anon-user", PageController, :anon_user_create

    resources "/tournaments", TournamentController
    get "/tournaments/join/:id", TournamentController, :join

    get "/games/play", GameController, :play
    post "/games/opponent_profile", GameController, :opponent_profile
    post "/games/player_score", GameController, :player_score
    post "/games/join", GameController, :join

    post "/friend/request", FriendController, :request
    post "/friend/confirm", FriendController, :confirm
    post "/friend/destroy", FriendController, :destroy

    resources "/registrations", RegistrationController, only: [:new, :create]

    get "/profile", ProfileController, :edit
    resources "/profiles", ProfileController, only: [:show, :update]

    get    "/login",  SessionController, :new
    post   "/login",  SessionController, :create
    delete "/logout", SessionController, :delete

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", K2pokerIo do
  #   pipe_through :api
  # end
end
