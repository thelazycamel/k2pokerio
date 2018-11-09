defmodule K2pokerIoWeb.RegistrationController do

  use K2pokerIoWeb, :controller
  alias K2pokerIo.User
  alias K2pokerIo.Commands.User.RegisterCommand

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render conn, changeset: changeset
  end

  def create(conn, params) do
    %{"user" => user_params} = params
    changeset = User.changeset(%User{}, Map.merge(user_params, %{"image" => "/images/profile-images/fish.png"}))
    case validate_recaptcha(params) do
      {:ok, _} ->
        case RegisterCommand.execute(changeset) do
          {:ok, changeset} ->
            conn
            |> put_session(:player_id, "user|#{changeset.id}")
            |> put_flash(:info, "Welcome to K2poker #{changeset.username}, ready to play?")
            |> redirect(to: tournament_path(conn, :index))
          {:error, changeset} ->
            conn
            |> put_flash(:error, "Sorry, we are unable to create the account, please check the errors below.")
            |> render("new.html", changeset: changeset)
        end
      {:error, _} ->
        conn
        |> put_flash(:error, "Human validation failed, please confirm you are not a robot")
        |> render("new.html", changeset: changeset)
    end

  end

  def validate_recaptcha(params) do
    unless Application.get_env(:k2poker_io, :env) == :test do
      Recaptcha.verify(params["g-recaptcha-response"])
    else
      {:ok, "test"}
    end
  end

end
