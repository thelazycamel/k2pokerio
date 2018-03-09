defmodule K2pokerIoWeb.RegistrationController do

  use K2pokerIoWeb, :controller
  alias K2pokerIo.User
  alias K2pokerIo.Commands.User.RegisterCommand

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render conn, changeset: changeset
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)

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
  end

end
