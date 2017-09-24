defmodule K2pokerIoWeb.Commands.Game.GetOpponentProfileCommand do

  alias K2pokerIo.Repo
  alias K2pokerIo.User
  alias K2pokerIo.UserTournamentDetail
  alias K2pokerIoWeb.Commands.User.GetFriendStatusCommand
  alias K2pokerIoWeb.Decorators.OpponentProfileDecorator

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
        |> add_friend_status(current_player_id, opponent_id)
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
    detail = Repo.one(from u in User, where: u.id == ^opponent_id, select: %{id: u.id, username: u.username, blurb: u.blurb, image: u.image})
    Map.put(detail, :opponent, "user")
  end

  defp add_friend_status(detail, current_player_id, opponent_player_id) do
    friend_status = cond do
      String.match?(current_player_id, ~r/^user/) ->
        {user_id, _} = get_id_from_player_id(current_player_id)
        {opponent_id, _} = get_id_from_player_id(opponent_player_id)
        GetFriendStatusCommand.execute(user_id, opponent_id)
      true -> :na
    end
    Map.put(detail, :friend, friend_status)
  end

  defp get_id_from_player_id(player_id) do
    String.split(player_id, "-")
    |> List.last
    |> Integer.parse
  end


  defp get_anon_detail(opponent_id) do
    detail = Repo.one(from u in UserTournamentDetail, where: u.player_id == ^opponent_id, select: %{id: u.id, username: u.username})
    Map.put(detail, :opponent, "anon")
  end

end
