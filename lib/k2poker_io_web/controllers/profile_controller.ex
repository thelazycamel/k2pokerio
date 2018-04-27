defmodule K2pokerIoWeb.ProfileController do

  use K2pokerIoWeb, :controller

  alias K2pokerIo.User

  def edit(conn, _params) do
    render(conn, "edit.html", profile: current_user(conn))
  end

  def settings(conn) do
    # link to here from profile for further settings
    # such as mail settings and crypto keys
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
