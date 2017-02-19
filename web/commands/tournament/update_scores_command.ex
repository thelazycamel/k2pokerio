defmodule K2pokerIo.Commands.Tournament.UpdateScoresCommand do

  alias K2pokerIo.Game
  alias K2pokerIo.Repo
  alias K2pokerIo.UserTournamentDetail
  import Ecto.Changeset

  def execute(game) do
    if game.open == true do
      Enum.each [game.player1_id, game.player2_id], fn (player_id) ->
        player_data = get_player_data(game, player_id)
        update_scores(game, player_id, player_data)
        update_badges(game, player_id, player_data)
      end
      game =mark_game_as_closed(game)
    end
    game
  end

  defp get_player_data(game, player_id) do
    game_data = Game.decode_game_data(game.data)
    K2poker.player_data(game_data, player_id)
  end

  defp update_scores(game, player_id, player_data) do
    utd = get_user_tournament_detail(player_id)
    score = utd.current_score
    new_score = case player_data.result.status do
      "win" -> score * 2
      "lose" -> 1
      "draw" -> score
      "folded" -> round(score / 2)
      "other_player_folded" -> score
      _ -> score
    end
    new_score = cond do
      new_score <= 1 -> 1
      true -> new_score
    end
    #new_score = 1 #THIS IS FOR TESTING PURPOSES TO KEEP THE PLAYERS ON THE SAME LEVEL
    update_user_tournament_detail(utd, game.id, new_score, player_id)
  end

  # TODO badges
  defp update_badges(game, player_id, player_data) do
    [game, player_id, player_data]
  end

  defp player_already_paid(game, player_id) do
    (player_id == game.player1_id && game.p1_paid == true) ||
    (player_id == game.player2_id && game.p2_paid == true)
  end

  # Get the game again to check that the player hasnt already been paid
  #
  defp update_user_tournament_detail(utd, game_id, score, player_id) do
    game = Repo.get(Game, game_id)
    unless player_already_paid(game, player_id) do
      changeset = UserTournamentDetail.changeset(utd, %{current_score: score})
      case Repo.update(changeset) do
        {:ok, _} -> mark_player_as_paid_out(game, player_id)
        {:error, _} -> nil
      end
    end
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

  defp mark_game_as_closed(game) do
    changeset = Game.changeset(game, %{open: false})
    {:ok, game} = Repo.update(changeset)
    game
  end

  defp get_user_tournament_detail(player_id) do
    Repo.get_by(UserTournamentDetail, player_id: player_id) |> Repo.preload([:game, :tournament])
  end

end
