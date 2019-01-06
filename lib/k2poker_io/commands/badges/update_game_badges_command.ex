defmodule K2pokerIo.Commands.Badges.UpdateGameBadgesCommand do

  alias K2pokerIo.Game
  alias K2pokerIo.User
  alias K2pokerIo.UserBadge
  alias K2pokerIo.UserTournamentDetail
  alias K2pokerIo.Commands.Badges.AddUserBadgeCommand

  def execute(game, player_id) do
    unless UserTournamentDetail.is_anon_user?(player_id) do
      player_data = get_player_data(game, player_id)
      if game_winner?(player_data, player_id) do
        check_for_badges(player_data, player_id, game)
      end
    end
    game
  end

  defp get_player_data(game, player_id) do
    Game.decode_game_data(game.data)
    |> K2poker.player_data(player_id)
  end

  defp check_for_badges(player_data, player_id, game) do
    process_four_of_a_kind(player_data, player_id, game)
    process_straight(player_data, player_id, game)
    process_flush(player_data, player_id, game)
    process_straight_flush(player_data, player_id, game)
    process_royal_flush(player_data, player_id, game)
    process_cracked_aces(player_data, player_id, game)
    process_k2(player_data, player_id, game)
  end

  defp game_winner?(player_data, player_id) do
    player_data.result.status == "win"
  end

  defp process_four_of_a_kind(player_data, player_id, game) do
    if player_data.result.win_description == "four_of_a_kind" do
      winning_cards = player_data.result.winning_cards
      cond do
        cards_match?(winning_cards, [~r/Jh/, ~r/Jc/, ~r/Jd/, ~r/Js/]) -> add_badge("4_jacks", player_id, game)
        cards_match?(winning_cards, [~r/Qh/, ~r/Qc/, ~r/Qd/, ~r/Qs/]) -> add_badge("4_queens", player_id, game)
        cards_match?(winning_cards, [~r/Kh/, ~r/Kc/, ~r/Kd/, ~r/Ks/]) -> add_badge("4_kings", player_id, game)
        cards_match?(winning_cards, [~r/Ah/, ~r/Ac/, ~r/Ad/, ~r/As/]) -> add_badge("4_aces", player_id, game)
        true -> true
      end
    end
  end

  defp process_straight(player_data, player_id, game) do
    if player_data.result.win_description == "straight" do
      winning_cards = player_data.result.winning_cards
      cond do
        cards_match?(winning_cards, [~r/A./, ~r/2./, ~r/3./, ~r/4./, ~r/5./]) -> add_badge("low_straight", player_id, game)
        cards_match?(winning_cards, [~r/T./, ~r/J./, ~r/Q./, ~r/K./, ~r/A./]) -> add_badge("high_straight", player_id, game)
        true -> true
      end
    end
  end

  defp process_straight_flush(player_data, player_id, game) do
    if player_data.result.win_description == "straight_flush" do
      add_badge("straight_flush", player_id, game)
    end
  end

  defp process_royal_flush(player_data, player_id, game) do
    if player_data.result.win_description == "royal_flush" do
      add_badge("royal_flush", player_id, game)
    end
  end

  defp process_flush(player_data, player_id, game) do
    if player_data.result.win_description == "flush" do
      winning_cards = player_data.result.winning_cards
      cond do
        cards_match?(winning_cards, [~r/Ah/, ~r/.h/, ~r/.h/, ~r/.h/]) -> add_badge("hearts_flush", player_id, game)
        cards_match?(winning_cards, [~r/Ac/, ~r/.c/, ~r/.c/, ~r/.c/]) -> add_badge("clubs_flush", player_id, game)
        cards_match?(winning_cards, [~r/Ad/, ~r/.d/, ~r/.d/, ~r/.d/]) -> add_badge("diamonds_flush", player_id, game)
        cards_match?(winning_cards, [~r/As/, ~r/.s/, ~r/.s/, ~r/.s/]) -> add_badge("spades_flush", player_id, game)
        true -> true
      end
    end
  end

  defp process_cracked_aces(player_data, player_id, game) do
    [card1, card2]  = player_data.result.other_player_cards
    if Regex.match?(~r/A./, card1) && Regex.match?(~r/A./, card2) do
      add_badge("cracked_aces", player_id, game)
    end
  end

  defp process_k2(player_data, player_id, game) do
    if cards_match?(player_data.result.player_cards, [~r/K./, ~r/2./]) do
      add_badge("k2_cards", player_id, game)
    end
  end

  defp cards_match?(cards, required_hand) do
    Enum.all?(required_hand, fn (regex) ->
      Enum.any?(cards, fn(card) -> Regex.match?(regex, card) end)
    end )
  end

  defp add_badge(action, player_id, game) do
    {:user, user_id} = User.get_id(player_id)
    {:ok, badges} = AddUserBadgeCommand.execute(action, user_id)
    if Enum.any?(badges) do
      broadcast_to_game_channel(badges, player_id, game)
    end
  end

  defp broadcast_to_game_channel(badges, player_id, game) do
    #TODO broadcast to user within the game channel so we can create an alert
  end

end
