defmodule K2pokerIo.Commands.Game.GetOpponentProfileCommand do

  alias K2pokerIo.User
  alias K2pokerIo.UserTournamentDetail
  alias K2pokerIo.Decorators.OpponentProfileDecorator
  alias K2pokerIo.Repo
  import Ecto.Query

  @doc "gets the opponents profile, with a given game and current_user returns dummy data for anon user or bot"

  def execute(game, current_player_id) do
    get_opponent(game, current_player_id)
    |> OpponentProfileDecorator.decorate
  end

  defp get_opponent(game, current_player_id) do
    opponent_id = get_opponent_id_from_game(game, current_player_id)
    cond do
      opponent_id == "" -> %{opponent: nil}
      opponent_id == nil -> %{opponent: nil}
      String.match?(opponent_id, ~r/^BOT/) -> %{opponent: "bot"}
      String.match?(opponent_id, ~r/^anon/) ->
        get_anon_detail(opponent_id)
      String.match?(opponent_id, ~r/^user/) ->
        id = List.last(String.split(opponent_id, "-"))
        get_opponent_detail(id)
      true -> %{opponent: nil}
    end
  end

  defp get_opponent_id_from_game(game, current_player_id) do
    cond do
      current_player_id == game.player1_id -> game.player2_id
      current_player_id == game.player2_id -> game.player1_id
      true -> nil
    end
  end

  defp get_opponent_detail(opponent_id) do
    detail = Repo.one(from u in User, where: u.id == ^opponent_id, select: %{id: u.id, username: u.username})
    Map.put(detail, :opponent, "user")
  end

  defp get_anon_detail(opponent_id) do
    detail = Repo.one(from u in UserTournamentDetail, where: u.player_id == ^opponent_id, select: %{id: u.id, username: u.username})
    Map.put(detail, :opponent, "anon")
  end

end
