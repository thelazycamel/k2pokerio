defmodule K2pokerIoWeb.ProfileController do

  use K2pokerIoWeb, :controller

  alias K2pokerIo.User
  alias K2pokerIo.Commands.User.UpdatePasswordCommand

  def edit(conn, _params) do
    gravatar = Gravity.image(current_user(conn).email, size: 200)
    render(conn, "edit.html", profile: current_user(conn), gravatar: gravatar)
  end

  def update_image(conn, %{"image" => image} ) do
    changeset = User.profile_changeset(current_user(conn), %{image: image})
    case Repo.update(changeset) do
      {:ok, _} -> json conn, %{status: :ok, image: image}
      {:error, _} -> json conn, %{status: :error}
    end
  end

  def update_blurb(conn, %{"blurb" => blurb} ) do
    changeset = User.profile_changeset(current_user(conn), %{blurb: blurb})
    case Repo.update(changeset) do
      {:ok, _} -> json conn, %{status: :ok, blurb: blurb}
      {:error, _} -> json conn, %{status: :error}
    end
  end

  def update_password(conn, %{"passwords" => passwords}) do
    case UpdatePasswordCommand.execute(current_user(conn), passwords) do
      {:ok} -> json conn, %{status: :ok}
      {:error, message} -> json conn, %{status: :error, message: message}
    end
  end

  def update(conn, %{"profile" => profile_params}) do
    changeset = User.profile_changeset(current_user(conn), profile_params)
    case Repo.update(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Profile Updated")
        |> redirect(to: profile_path(conn, :edit))
      {:error, _} ->
        conn
        |> put_flash(:info, "An error occurred, please try again")
        |> redirect(to: profile_path(conn, :edit))
    end
  end

end
