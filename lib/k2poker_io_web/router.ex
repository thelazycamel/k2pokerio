defmodule K2pokerIoWeb.Router do

  use K2pokerIoWeb, :router

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

  scope "/", K2pokerIoWeb do
    pipe_through :browser # Use the default browser stack

    post "/anon-user", PageController, :anon_user_create

    resources "/tournaments", TournamentController
    get "/tournaments/join/:id", TournamentController, :join
    post "/tournaments/for_user", TournamentController, :for_user
    post "/tournaments/get_scores", TournamentController, :get_scores

    get "/games/play", GameController, :play
    post "/games/opponent_profile", GameController, :opponent_profile
    post "/games/player_score", GameController, :player_score
    post "/games/join", GameController, :join

    post "/friend/request", FriendController, :request
    post "/friend/confirm", FriendController, :confirm
    post "/friend/destroy", FriendController, :destroy
    post "/friend/search", FriendController, :search

    get "/invitation/accept/:id", InvitationController, :accept
    post "/invitation/destroy", InvitationController, :destroy

    resources "/registrations", RegistrationController, only: [:new, :create]

    get "/profile", ProfileController, :edit
    post "/profile/image", ProfileController, :image
    post "/profile/blurb", ProfileController, :blurb

    resources "/profiles", ProfileController, only: [:update]

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
