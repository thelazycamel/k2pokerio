defmodule K2pokerIo.Commands.Game.QuitGameCommand do

  alias K2pokerIo.Game
  alias K2pokerIo.UserTournamentDetail
  alias K2pokerIo.Repo
  alias Ecto.Multi

  import Ecto.Query

  def execute(utd) do
    if game_can_be_closed?(utd.game) do
      close_game(utd.game)
    else
      false
    end
  end

  def game_can_be_closed?(game) do
    game.waiting_for_players && !game.player2_id
  end

  defp close_game(game) do
    case Repo.update(Game.close_changeset(game, %{open: false, waiting_for_players: false})) do
     {:ok, _} -> true
     _ -> false
    end
  end

end
