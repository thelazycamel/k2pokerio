defmodule K2pokerIo.Commands.Badges.UpdateTournamentBadgesCommand do

  alias K2pokerIo.UserTournamentDetail
  alias K2pokerIo.User
  alias K2pokerIo.Commands.Badges.AddUserBadgeCommand

  def execute(tournament, player_id) do
    unless UserTournamentDetail.is_anon_user?(player_id) do
      check_for_badges(tournament, player_id)
    end
  end

  defp check_for_badges(tournament, player_id) do
    process_k2_tournament(tournament, player_id)
    process_crypto_tournament(tournament, player_id)
    process_private_tournament(tournament, player_id)
    process_duel(tournament, player_id)
  end

  defp process_k2_tournament(tournament, player_id) do
    if tournament.default_tournament do
      add_badge("k2_winner", player_id, tournament)
    end
  end

  defp process_crypto_tournament(tournament, player_id) do
    #TODO: possible add a new field to tournament "crypto" or a new table "cryptos" with a crypto_id...
  end

  defp process_private_tournament(tournament, player_id) do
    if tournament.private && tournament.tournament_type == "tournament" do
      add_badge("private_winner", player_id, tournament)
    end
  end

  def process_duel(tournament, player_id) do
    if tournament.private && tournament.tournament_type == "duel" do
      add_badge("duel_winner", player_id, tournament)
    end
  end

  defp add_badge(action, player_id, tournament) do
    {:user, user_id} = User.get_id(player_id)
    {:ok, badges} = AddUserBadgeCommand.execute(action, user_id)
    if Enum.any?(badges) do
      broadcast_to_tournament_channel(badges, player_id, tournament.id)
    end
  end

  defp broadcast_to_tournament_channel(badges, player_id, tournament_id) do
    payload = %{player_id: player_id, badges: badges}
    K2pokerIoWeb.Endpoint.broadcast!("tournament:#{tournament_id}", "tournament:badge_awarded", payload)
  end

end
