defmodule K2pokerIo.ProfileController do
  use K2pokerIo.Web, :controller

  alias K2pokerIo.User

  def show(conn, %{id: id}) do
    user = Repo.get(User, id)
    render(conn, "show.html", user: user)
  end

  def edit(conn, _params) do
    render(conn, "edit.html", profile: current_user(conn))
  end

  def update(conn, %{"id" => id, "profile" => profile_params}) do
    changeset = User.profile_changeset(current_user(conn), profile_params)
    case Repo.update(changeset) do
      {:ok, profile} ->
        conn
        |> put_flash(:info, "Profile Updated")
        |> redirect(to: profile_path(conn, :edit))
      {:error, profile} ->
        conn
        |> put_flash(:info, "An error occurred, please try again")
        |> redirect(to: profile_path(conn, :edit))
    end
  end

end
