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

    get "/tournaments/for_user", TournamentController, :for_user
    get "/tournaments/join/:id", TournamentController, :join
    post "/tournaments/get_scores", TournamentController, :get_scores
    resources "/tournaments", TournamentController

    get "/games/play", GameController, :play
    post "/games/join", GameController, :join
    post "/games/quit", GameController, :quit
    post "/games/opponent_profile", GameController, :opponent_profile
    post "/games/player_score", GameController, :player_score
    post "/games/duel_fix", GameController, :duel_fix

    resources "/friends", FriendController, only: [:index, :create, :delete]
    post "/friends/confirm", FriendController, :confirm
    get "/friends/status/:user_id", FriendController, :status
    get "/friends/count/:action", FriendController, :count
    get "/friends/search", FriendController, :search
    get "/friends/friends_only", FriendController, :friends_only

    resources "/badges", BadgeController, only: [:index]
    get "/badges/gold", BadgeController, :gold

    resources "/invitations", InvitationController, only: [:index, :delete]
    get "/invitations/accept/:id", InvitationController, :accept
    get "/invitations/count", InvitationController, :count

    resources "/registrations", RegistrationController, only: [:new, :create]

    get "/profile", ProfileController, :edit
    post "/profile/update_image", ProfileController, :update_image
    post "/profile/update_blurb", ProfileController, :update_blurb
    post "/profile/update_password", ProfileController, :update_password

    get    "/login",  SessionController, :new
    post   "/login",  SessionController, :create
    delete "/logout", SessionController, :delete

    get    "/password", PasswordController, :forgotten
    post   "/password", PasswordController, :request
    get    "/password/:token", PasswordController, :create_new
    post   "/password/update", PasswordController, :update

    get "/rules", PageController, :rules
    get "/terms", PageController, :terms
    get "/about", PageController, :about
    get "/promo", PageController, :promo


    get "/", PageController, :index
  end

end
