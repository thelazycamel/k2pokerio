defmodule K2pokerIo.Fixtures.SetUp do

  alias K2pokerIo.Fixtures.UserTournamentDetailFixture
  alias K2pokerIo.UserTournamentDetail
  alias K2pokerIo.Game
  alias K2pokerIo.Fixtures.TournamentFixture
  alias K2pokerIo.Fixtures.GameFixture
  alias K2pokerIo.Repo

  # basic_set_up, sets up a game with a List of 2 players and returns
  # a map %{player1: p1, player2: p2, game: game} (where p1, p2 are user_tournament_details)
  #
  def basic_set_up(players) do
    create_tournament
    |> create_user_tournament_details(players)
    |> create_game
  end

  defp create_tournament do
    TournamentFixture.create
  end

  defp create_user_tournament_details(tournament, players) do
    Enum.map(players, fn(player) ->
      UserTournamentDetailFixture.create(%{username: player, tournament_id: tournament.id})
    end)
  end

  def create_game(utds) do
    games = Enum.map(utds, fn(user_tournament_detail) ->
      GameFixture.create(user_tournament_detail)
    end)
    {:ok, game} = List.last(games)
    %{
      player1: Repo.get(UserTournamentDetail, List.first(utds).id),
      player2: Repo.get(UserTournamentDetail, List.last(utds).id),
      game: game
     }
  end

end

