defmodule K2pokerIo.Commands.Tournament.UpdatePlayerScoreCommand do

  alias K2pokerIo.Repo
  alias K2pokerIo.Game
  alias K2pokerIo.UserTournamentDetail
  alias K2pokerIo.Commands.Tournament.UpdateTournamentCommand

  # TODO look at locking the database during these updates

  def execute(game, player_id) do
    update_score(game, player_id)
  end

  defp update_score(game, player_id) do
    player_data = get_player_data(game, player_id)
    utd = get_user_tournament_detail(player_id, game.tournament_id)
    score = utd.current_score
    new_score = case player_data.result.status do
      "win" -> score * 2
      "lose" -> tournament_lose_policy(score, utd.tournament)
      "draw" -> score
      "folded" -> round(score / 2)
      "other_player_folded" -> score
      _ -> score
    end
    new_score = if new_score <= 1, do: 1, else: new_score
    utd = update_user_tournament_detail(utd, game.id, new_score, player_id)
    if new_score >= utd.tournament.max_score do
      update_tournament(game, utd)
    end
    game
  end

  defp get_player_data(game, player_id) do
    Game.decode_game_data(game.data)
    |> K2poker.player_data(player_id)
  end

  defp tournament_lose_policy(score, tournament) do
    case tournament.lose_type do
      "all" -> 1
      "half" -> round(score / 2)
    end
  end

  defp update_user_tournament_detail(utd, game_id, score, player_id) do
    game = Repo.get(Game, game_id)
    unless player_already_paid(game, player_id) do
      changeset = UserTournamentDetail.changeset(utd, %{current_score: score})
      case Repo.update(changeset) do
        {:ok, utd} ->
          mark_player_as_paid_out(game, player_id)
          utd
        {:error, _} -> nil
      end
    end
  end

  defp player_already_paid(game, player_id) do
    (player_id == game.player1_id && game.p1_paid == true) ||
    (player_id == game.player2_id && game.p2_paid == true)
  end

  defp get_user_tournament_detail(player_id, tournament_id) do
    Repo.get_by(UserTournamentDetail, player_id: player_id, tournament_id: tournament_id) |> Repo.preload([:game, :tournament])
  end

  defp mark_player_as_paid_out(game, player_id) do
    game_p1 = game.player1_id
    game_p2 = game.player2_id
    updates = case player_id do
      ^game_p1 -> %{p1_paid: true}
      ^game_p2 -> %{p2_paid: true}
      _ -> %{}
    end
    changeset = Game.changeset(game, updates)
    Repo.update(changeset)
  end

  defp update_tournament(game, utd) do
    UpdateTournamentCommand.execute(game, utd)
  end

end
