defmodule K2pokerIo.Commands.Game.JoinCommand do

  alias K2pokerIo.Game
  alias K2pokerIo.UserTournamentDetail
  alias K2pokerIo.Repo
  import Ecto
  import Ecto.Query

  def execute(user_tournament_detail) do
    case find_or_create_game(user_tournament_detail) do
     {:ok, game} ->
       update_user_tournament_detail(user_tournament_detail, game)
       {:ok, game}
     {:error} -> {:error}
    end
  end

  defp find_or_create_game(user_tournament_detail) do
    if game = get_game(user_tournament_detail) do
      join_game(user_tournament_detail, game)
    else
      create_new_game(user_tournament_detail)
    end
  end

  defp join_game(utd, game) do
    game_changeset = Game.join_changeset(game, %{player2_id: utd.player_id, waiting_for_players: false})
    case Repo.update(game_changeset) do
      {:ok, existing_game} -> {:ok, existing_game}
      {:error, _} -> {:error}
    end
  end

  defp create_new_game(utd) do
    changeset = Game.create_new_changeset(%Game{}, %{
      player1_id:          utd.player_id,
      tournament_id:       utd.tournament_id,
      value:               utd.current_score,
      waiting_for_players: true,
      open: true
    })
    case Repo.insert(changeset) do
      {:ok, game} -> {:ok, game}
      {:error, _} -> {:error}
    end
  end

  defp update_user_tournament_detail(utd, game) do
    utd_changeset = UserTournamentDetail.changeset(utd, %{game_id: game.id})
    Repo.update(utd_changeset)
  end

  defp get_game(utd) do
    tournament = utd.tournament
    cond do
      tournament.private && tournament.bots == false -> any_available_game(utd)
      true -> game_by_current_score(utd)
    end
  end

  defp any_available_game(utd) do
    query = from Game, where: [tournament_id: ^utd.tournament_id,
                       waiting_for_players: true,
                       open: true
                       ], limit: 1
    List.first(Repo.all(query))
  end

  defp game_by_current_score(utd) do
    query = from Game, where: [tournament_id: ^utd.tournament_id,
                       value: ^utd.current_score,
                       waiting_for_players: true,
                       open: true
                       ], limit: 1
    List.first(Repo.all(query))
  end

end
