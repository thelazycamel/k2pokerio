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

    # TODO: Put the ajax calls in here and move
    # their controllers to the /controllers/api/
    # directory, routes need tidying up

  end

  scope "/", K2pokerIoWeb do

    pipe_through :browser # Use the default browser stack

    # There are only very few actual pages, so most of these
    # routes should be moved to the api scope.

    post "/anon-user", PageController, :anon_user_create

    resources "/tournaments", TournamentController
    get "/tournaments/join/:id", TournamentController, :join
    post "/tournaments/for_user", TournamentController, :for_user
    post "/tournaments/get_scores", TournamentController, :get_scores

    get "/games/play", GameController, :play
    post "/games/opponent_profile", GameController, :opponent_profile
    post "/games/player_score", GameController, :player_score
    post "/games/join", GameController, :join

    resources "/friends", FriendController, only: [:index, :show, :create, :delete]
    post "/friends/confirm", FriendController, :confirm
    post "/friends/search", FriendController, :search

    get "/invitation/accept/:id", InvitationController, :accept
    post "/invitation/destroy", InvitationController, :destroy

    resources "/registrations", RegistrationController, only: [:new, :create]

    get "/profile", ProfileController, :edit
    post "/profile/update_image", ProfileController, :update_image
    post "/profile/update_blurb", ProfileController, :update_blurb
    post "/profile/update_password", ProfileController, :update_password

    resources "/profiles", ProfileController, only: [:update]

    get    "/login",  SessionController, :new
    post   "/login",  SessionController, :create
    delete "/logout", SessionController, :delete

    get "/", PageController, :index
  end

end
