defmodule K2pokerIoWeb.PasswordController do

  use K2pokerIoWeb, :controller

  alias K2pokerIo.Commands.User.RequestNewPasswordCommand
  alias K2pokerIo.Commands.User.GetUserFromTokenCommand
  alias K2pokerIo.Commands.User.UpdatePasswordWithTokenCommand

  def forgotten(conn, _params) do
    if logged_in?(conn) do
      redirect conn, to: Routes.tournament_path(conn, :index)
    else
      render conn, "forgotten.html"
    end
  end

  def request(conn, params) do
    case validate_recaptcha(params) do
      {:ok, _} ->
        case RequestNewPasswordCommand.execute(params["user"]["email"]) do
          {:ok, _} ->
            render(conn, "email_sent.html")
          {:error, message} ->
            conn
            |> put_flash(:error, "Seems like a wrong Email")
            |> render("forgotten.html")
        end
      {:error, _} ->
        conn
        |> put_flash(:error, "Human validation failed, please confirm you are not a robot")
        |> render("forgotten.html")
    end
  end

  def create_new(conn, %{"token" => token}) do
    if logged_in?(conn) do
      redirect conn, to: Routes.tournament_path(conn, :index)
    else
      case GetUserFromTokenCommand.execute(token) do
        {:ok, _ } ->
          render conn, "create_new.html", token: token
        {:error, message} ->
          conn
          |> put_flash(:error, message)
          |> render "forgotten.html"
      end
    end
  end

  def update(conn, params) do
    case UpdatePasswordWithTokenCommand.execute(params["token"], params["password"], params["password_confirmation"]) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Your password has been changed, please login")
        |> redirect(to: "/")
      {:error, message} ->
        conn
        |> put_flash(:error, message)
        |> render("create_new.html", %{token: params["token"]})
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
