defmodule K2pokerIoWeb.TournamentController do

  use K2pokerIoWeb, :controller

  alias K2pokerIo.Queries.Friends.FriendsQuery
  alias K2pokerIo.Queries.Tournaments.GetPlayersQuery
  alias K2pokerIo.Queries.Tournaments.GetTournamentsForUserQuery
  alias K2pokerIo.Commands.Tournament.CreateTournamentCommand
  alias K2pokerIo.Commands.Tournament.JoinTournamentCommand
  alias K2pokerIo.Commands.Tournament.DestroyTournamentCommand
  alias K2pokerIo.Policies.Tournament.AccessPolicy
  alias K2pokerIo.Queries.Tournaments.GetWinnersQuery
  alias K2pokerIo.Tournament
  alias K2pokerIo.UserTournamentDetail
  alias K2pokerIo.Repo

  import Ecto.Query

  def index(conn, _) do
    if player_id = get_session(conn, :player_id) do
      %{username: username, image: profile_image} = current_user(conn)
      render(conn, "index.html", logged_in: logged_in?(conn), tournament_id: Tournament.default.id, player_id: player_id, username: username, profile_image: profile_image)
    else
      redirect conn, to: "/"
    end
  end

  def show(conn, %{"id" => tournament_id}) do
    player_id = get_session(conn, :player_id)
    tournament = get_tournament(tournament_id)
    players = GetPlayersQuery.all(tournament_id)
    if current_user(conn) && AccessPolicy.accessible?(current_user(conn), tournament) do
      render(conn, "show.html", logged_in: logged_in?(conn), tournament_id: tournament.id, player_id: player_id, tournament: tournament, players: players)
    else
      redirect conn, to: "/"
    end

  end

  def for_user(conn, _) do
    if logged_in?(conn) do
      tournaments = GetTournamentsForUserQuery.for_user(current_user(conn))
      json conn, tournaments
    else
      json conn, %{error: true}
    end
  end

  def get_scores(conn, _) do
    utd = get_user_tournament_detail(conn)
    scores = GetWinnersQuery.current_winners(utd.player_id, utd.tournament)
    json conn, scores
  end

  def join(conn, %{"id" => id}) do
    case JoinTournamentCommand.execute(current_user(conn), id) do
      {:ok, utd_id: utd_id} ->
        conn = put_session(conn, :utd_id, utd_id)
        redirect conn, to: game_path(conn, :play)
      {:error, _} -> redirect conn, to: page_path(conn, :index)
    end
  end

  def new(conn, params) do
    if logged_in?(conn) do
      {query, kerosene} = FriendsQuery.friends_only(current_user(conn).id, params)
      friends = FriendsQuery.decorate_friendships(query, current_user(conn).id)
      render conn, "new.html", %{friends: friends, kerosene: kerosene}
    else
      redirect conn, to: "/"
    end
  end

  def create(conn, %{"tournament" => tournament_params}) do
    if logged_in?(conn) do
      case CreateTournamentCommand.execute(current_user(conn), tournament_params) do
        {:ok, _} -> redirect conn, to: tournament_path(conn, :index)
        {:error, message} -> conn
          |> put_flash(:error, message)
          |> redirect(to: tournament_path(conn, :new))
      end
    else
      redirect conn, to: "/"
    end
  end

  def delete(conn, %{"id" => id}) do
    id = String.to_integer(id)
    DestroyTournamentCommand.execute(current_user(conn), id)
    json conn, %{tournament_id: id}
  end

  #PRIVATE METHODS

  defp get_tournament(tournament_id) do
    Repo.one from(t in Tournament, where: t.id == ^tournament_id)
  end

  defp get_user_tournament_detail(conn) do
    if utd_id = get_session(conn, :utd_id) do
      Repo.get(UserTournamentDetail, utd_id) |> Repo.preload([:game, :tournament])
    else
      nil
    end
  end

end
