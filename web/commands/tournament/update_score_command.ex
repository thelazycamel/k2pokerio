defmodule K2pokerIo.Commands.Tournament.UpdateScoreCommand do

  alias K2pokerIo.Game
  alias K2pokerIo.Repo
  alias K2pokerIo.UserTournamentDetail
  import Ecto.Changeset

  @spec execute(Game.t, String.t) :: Atom.t

  def execute(game, player_id) do
    unless already_paid_out?(game, player_id) do
      player_data = get_player_data(game, player_id)
      update_scores(game, player_id, player_data)
      update_badges(game, player_id, player_data)
    end
    :ok
  end

  defp get_player_data(game, player_id) do
    Game.decode_game_data(game.data)
    |> K2poker.player_data(player_id)
  end

  defp already_paid_out?(game, player_id) do
    game_p1 = game.player1_id
    game_p2 = game.player2_id
    bob =case player_id do
      ^game_p1 -> game.p1_paid
      ^game_p2 -> game.p2_paid
      _ -> true
    end
  end

  #TODO work out folded status etc
  #
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
    update_user_tournament_detail(utd, game, new_score, player_id)
  end

  defp update_badges(game, player_id, player_data) do
    #TODO
    [game, player_id, player_data]
  end

  defp update_user_tournament_detail(utd, game, score, player_id) do
    changeset = UserTournamentDetail.changeset(utd, %{current_score: score})
    case Repo.update(changeset) do
      {:ok, _} -> mark_player_as_paid_out(game, player_id)
      {:error, _} -> nil
    end
  end

  defp mark_player_as_paid_out(game, player_id) do
    game_p1 = game.player1_id
    game_p2 = game.player2_id
    updates = case player_id do
      ^game_p1 -> %{p1_paid: true, open: false}
      ^game_p2 -> %{p2_paid: true, open: false}
      _ -> %{}
    end
    changeset = Game.changeset(game, updates)
    Repo.update(changeset)
  end

  defp get_user_tournament_detail(player_id) do
    Repo.get_by(UserTournamentDetail, player_id: player_id) |> Repo.preload(:game) |> Repo.preload(:tournament)
  end

end

