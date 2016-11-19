defmodule K2pokerIo.PageController do
  use K2pokerIo.Web, :controller

  alias K2pokerIo.UserTournamentDetail

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
    anon_username = String.replace(anon_username, ~r/\W/, " ") #dumb security to remove all non-word chrs
    player_id = generate_anon_player_id(anon_username)
    conn = put_session(conn, :player_id, player_id)
    default_tournament = Repo.get_by(K2pokerIo.Tournament, default: true)
    case create_user_tournament_detail(anon_username, player_id, default_tournament) do
      {:ok, _} ->
        redirect conn, to: tournament_path(conn, :show, default_tournament.id)
      {:error, _} ->
        redirect conn, to: page_path(conn, :index)
    end
  end

  # Generate an anonomous user_id -> "anon|*username*|*random_hash*"
  # remove any non-word chars from the username
  # TODO move these methods, probably to the user model, maybe create "commands"
  #

  # TODO this can be moved to the user_tournament_detail model as set default tournament there
  defp create_user_tournament_detail(username, player_id, default_tournament) do
    detail = %{player_id: player_id, username: username, tournament_id: default_tournament.id, current_score: 1, rebuys: [0]}
    changeset = UserTournamentDetail.changeset(%UserTournamentDetail{}, detail)
    case Repo.insert(changeset) do
      {:ok, user_tournament_detail} ->
        {:ok, user_tournament_detail}
      {:error, changeset} ->
        {:error, changeset}
    end
  end

  defp generate_anon_player_id(anon_username) do
    anon_username = String.replace(anon_username, " ", "")
    "anon|" <> anon_username <> random_hash(32)
  end

  # generate a random_hash, replace any | so we can enable splitting by them in the player_id
  defp random_hash(length) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length) |> String.replace("|", "-")
  end

end
