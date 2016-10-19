defmodule K2pokerIo.PageController do
  use K2pokerIo.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def test(conn, _params) do
    game = K2poker.new("stu", "bob")
      |> K2poker.play("bob")
      |> K2poker.play("stu")
      |> K2poker.play("bob")
      |> K2poker.play("stu")
      |> K2poker.play("bob")
      |> K2poker.play("stu")
      |> K2poker.play("bob")
      |> K2poker.play("stu")
    render conn, "test.html", game: game
  end

  #TODO validate/restrict chars and secure this user generated username
  def anon_user_create(conn, %{"anon_user" => %{"username" => anon_username}}) do
    user_id = generate_anon_user_id(anon_username)
    default_tournament = Repo.get_by(K2pokerIo.Tournament, default: true)

    redirect conn, to: tournament_path(conn, :show, default_tournament.id)
  end

  # Generate an anonomous user_id -> "anon|*username*|*random_hash*"
  # remove any non-word chars from the username
  # TODO move these methods, probably to the user model
  #
  defp generate_anon_user_id(username) do
    "anon|" <> String.replace(username, ~r/\W/, "") <> "|" <> random_hash(32)
  end

  # generate a random_hash, replace any | so we can enable splitting by them in the user_id
  defp random_hash(length) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length) |> String.replace("|", "-")
  end

end
