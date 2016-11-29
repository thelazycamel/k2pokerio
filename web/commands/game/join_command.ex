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
    if game = List.first(Repo.all(game_waiting_query(user_tournament_detail))) do
      join_game(user_tournament_detail, game)
    else
      create_new_game(user_tournament_detail)
    end
  end

  defp join_game(utd, game) do
    game_changeset = Game.join_changeset(game, %{player2_id: utd.player_id, waiting_for_players: false})
    case Repo.update(game_changeset) do
      {:ok, existing_game} -> {:ok, existing_game}
      {:error, changeset} -> {:error}
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
      {:error, changeset} -> {:error}
    end
  end

  defp update_user_tournament_detail(utd, game) do
    utd_changeset = UserTournamentDetail.changeset(utd, %{game_id: game.id})
    Repo.update(utd_changeset)
  end

  # TODO check created_at for being less than 1 minute and make sure player2_id is null
  #
  defp game_waiting_query(utd) do
    from Game, where: [tournament_id: ^utd.tournament_id,
                       value: ^utd.current_score,
                       waiting_for_players: true,
                       open: true
                       ], limit: 1
  end

end
