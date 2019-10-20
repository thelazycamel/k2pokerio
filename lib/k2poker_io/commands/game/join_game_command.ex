defmodule K2pokerIo.Commands.Game.JoinGameCommand do

  alias K2pokerIo.Game
  alias K2pokerIo.UserTournamentDetail
  alias K2pokerIo.Repo
  alias Ecto.Multi

  import Ecto.Query

  def execute(user_tournament_detail) do
    user_tournament_detail = check_valid_score!(user_tournament_detail)
    find_or_create_game(user_tournament_detail)
  end

  defp check_valid_score!(user_tournament_detail) do
    if current_score_is_greater_than_max?(user_tournament_detail), do: reset_current_score(user_tournament_detail), else: user_tournament_detail
  end

  # On the default tournament where the tournament does not finish
  # the users score needs to be reset if it goes over the tournament max_score
  #
  defp reset_current_score(user_tournament_detail) do
    Repo.update!(UserTournamentDetail.changeset(user_tournament_detail, %{current_score: user_tournament_detail.tournament.starting_chips}))
  end

  defp current_score_is_greater_than_max?(user_tournament_detail) do
    user_tournament_detail.current_score >= user_tournament_detail.tournament.max_score
  end

  defp find_or_create_game(utd) do
    Multi.new()
    |> Multi.run(:find_game, fn _repo, %{} -> find_game_waiting(utd) end)
    |> Multi.run(:game, fn _repo, %{find_game: find_game}  ->
      if find_game do
        Repo.update(join_game_changeset(utd, find_game))
      else
        Repo.insert(create_new_game_changeset(utd))
      end
    end)
    |> Multi.run(:update_utd, fn _repo, %{game: game} -> Repo.update(update_utd_changeset(utd, game)) end)
    |> Repo.transaction
    |> case do
      {:ok, %{find_game: _, game: game, update_utd: _}} -> {:ok, game}
      {:error, _, _, _} -> {:error}
    end
  end

  defp find_game_waiting(utd) do
    tournament = utd.tournament
    game = cond do
      tournament.tournament_type == "duel" -> any_available_game(utd)
      true -> game_by_current_score(utd)
    end
    {:ok, game}
  end

  defp game_by_current_score(utd) do
    query = from Game, where: [tournament_id: ^utd.tournament_id,
                       value: ^utd.current_score,
                       waiting_for_players: true,
                       open: true,
                       ], limit: 1, preload: [:tournament], lock: "FOR UPDATE"
    List.first(Repo.all(query))
  end

  defp any_available_game(utd) do
    query = from Game, where: [tournament_id: ^utd.tournament_id,
                       waiting_for_players: true,
                       open: true
                       ], limit: 1, preload: [:tournament]
    Repo.all(query) |> List.first
  end

  defp join_game_changeset(utd, game) do
    Game.join_changeset(game, %{
      player2_id: utd.player_id,
      p2_timestamp: NaiveDateTime.utc_now,
      waiting_for_players: false
    })
  end

  defp create_new_game_changeset(utd) do
    Game.new_changeset(%Game{}, %{
      player1_id:          utd.player_id,
      p1_timestamp:        NaiveDateTime.utc_now,
      tournament_id:       utd.tournament_id,
      value:               utd.current_score,
      waiting_for_players: true,
      open: true
    })
  end

  defp update_utd_changeset(utd, game) do
    UserTournamentDetail.changeset(utd, %{game_id: game.id})
  end

end
