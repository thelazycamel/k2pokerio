defmodule K2pokerIo.Commands.Tournament.UpdatePlayerScoreCommand do

  alias K2pokerIo.Repo
  alias K2pokerIo.Game
  alias K2pokerIo.UserTournamentDetail
  alias K2pokerIo.Commands.Tournament.UpdateTournamentWinnerCommand
  alias Ecto.Multi

  import Ecto.Query

  def execute(game, player_id) do
    calculate_score(game, player_id)
  end

  defp calculate_score(game, player_id) do
    player_data = get_player_data(game, player_id)
    utd = get_user_tournament_detail(player_id, game.tournament_id)
    score = utd.current_score
    new_score = case player_data.result.status do
      "win" -> score * 2
      "lose" -> tournament_lose_policy(score, utd.tournament)
      "draw" -> score
      "folded" -> player_folded_policy(score, utd)
      "other_player_folded" -> score
      _ -> score
    end
    new_score = if new_score <= 1, do: 1, else: new_score
    update_players_score(game, utd, new_score, player_data.result.status)
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

  # uses Ecto.Multi to do a multi transaction to ensure the score does not get
  # updated twice or tournament winners sent twice, requires the lock nowait,
  # to make the 2nd process fall over and rollback during transaction
  #
  defp update_players_score(game, utd, score, status) do
    game = Multi.new()
    |> Multi.run(:get_game, fn %{} ->
      {:ok, Repo.one(from g in Game, where: g.id == ^game.id, lock: "FOR SHARE NOWAIT", preload: [:tournament]) }
     end)
    |> Multi.run(:updateable, fn %{get_game: get_game} -> score_already_updated?(get_game, utd.player_id) end)
    |> Multi.update(:utd, UserTournamentDetail.changeset(utd, utd_changeset(game, score, status)))
    |> Multi.run(:game, fn %{get_game: get_game, utd: utd} -> Repo.update(game_update_changeset(get_game, utd.player_id)) end)
    |> Multi.run(:update_tournament_winner, fn %{utd: utd, game: game} -> check_tournament_winner(game, utd) end)
    |> Repo.transaction
    |> case do
      {:ok, %{get_game: get_game, updateable: _, utd: _, game: _, update_tournament_winner: _}} -> get_game
      {:error, _, value, _} -> game
    end
  end

  def utd_changeset(game, score, status) do
    cond do
      status == "folded" && game.tournament.type == "duel" -> %{current_score: score, fold: false}
      status == "other_player_folded" && game.tournament.type == "duel" -> %{current_score: score, fold: true}
      true -> %{current_score: score}
    end
  end


  defp score_already_updated?(game, player_id) do
    result = cond do
      player_id == game.player1_id && game.p1_paid == true -> {:error, "Already Updated"}
      player_id == game.player2_id && game.p2_paid == true -> {:error, "Already Updated"}
      true -> {:ok, "Ready for update!"}
    end
    {type, value} = result
    result
  end

  defp get_user_tournament_detail(player_id, tournament_id) do
    Repo.get_by(UserTournamentDetail, player_id: player_id, tournament_id: tournament_id) |> Repo.preload([:game, :tournament])
  end

  defp check_tournament_winner(game, utd) do
    if utd.current_score >= game.tournament.max_score, do: {:ok, update_tournament_winner(game, utd)}, else: {:ok, game}
  end

  defp game_update_changeset(game, player_id) do
    updates = cond do
      player_id == game.player1_id -> %{p1_paid: true}
      player_id == game.player2_id -> %{p2_paid: true}
      true -> %{}
    end
    Game.changeset(game, updates)
  end

  defp mark_player_as_paid_out(game, player_id) do
    updates = cond do
      player_id == game.player1_id -> %{p1_paid: true}
      player_id == game.player2_id -> %{p2_paid: true}
      true -> %{}
    end
    changeset = Game.changeset(game, updates)
    Repo.update!(changeset) |> Repo.preload(:tournament)
  end

  defp update_tournament_winner(game, utd) do
    UpdateTournamentWinnerCommand.execute(game, utd)
  end

  defp player_folded_policy(score, utd) do
    if utd.tournament.type == "duel" do
      score
    else
      round(score / 2)
    end
  end

end
