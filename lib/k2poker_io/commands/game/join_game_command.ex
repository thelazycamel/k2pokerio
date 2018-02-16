defmodule K2pokerIo.Commands.Game.JoinGameCommand do

  alias K2pokerIo.Game
  alias K2pokerIo.UserTournamentDetail
  alias K2pokerIo.Repo

  import Ecto.Query

  def execute(user_tournament_detail) do
    user_tournament_detail = check_valid_score!(user_tournament_detail)
    case find_or_create_game(user_tournament_detail) do
     {:ok, game} ->
       update_user_tournament_detail(user_tournament_detail, game)
       {:ok, game}
     {:error} -> {:error}
    end
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

  defp find_or_create_game(user_tournament_detail) do
    if game = get_game(user_tournament_detail) do
      join_game(user_tournament_detail, game)
    else
      create_new_game(user_tournament_detail)
    end
  end

  defp join_game(utd, game) do
    game_changeset = Game.join_changeset(game, %{
      player2_id: utd.player_id,
      p2_timestamp: Ecto.DateTime.utc,
      waiting_for_players: false
      })
    case Repo.update(game_changeset) do
      {:ok, existing_game} -> {:ok, existing_game}
      {:error, _} -> {:error}
    end
  end

  defp create_new_game(utd) do
    changeset = Game.new_changeset(%Game{}, %{
      player1_id:          utd.player_id,
      p1_timestamp:        Ecto.DateTime.utc,
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
                       ], limit: 1, preload: [:tournament]
    List.first(Repo.all(query))
  end

  defp game_by_current_score(utd) do
    query = from Game, where: [tournament_id: ^utd.tournament_id,
                       value: ^utd.current_score,
                       waiting_for_players: true,
                       open: true,
                       ], limit: 1, preload: [:tournament]
    List.first(Repo.all(query))
  end

end
