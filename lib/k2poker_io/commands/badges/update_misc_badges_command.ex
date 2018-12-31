defmodule K2pokerIo.Commands.Badges.UpdateMiscBadgesCommand do

  alias K2pokerIo.UserTournamentDetail

  def execute(action, player_id) do
    unless UserTournamentDetail.is_anon_user?(player_id) do
      check_action(action, player_id)
    end
  end

  defp check_action(action, player_id) do
    case action do
      :profile -> check_profile_badge(player_id)
      _ -> IO.puts "ERROR: no misc badge action set"
    end
  end

  defp check_profile_badge(player_id) do

  end

end
