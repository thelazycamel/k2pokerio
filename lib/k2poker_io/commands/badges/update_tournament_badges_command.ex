defmodule K2pokerIo.Commands.Badges.UpdateTournamentBadgesCommand do

  alias K2pokerIo.UserTournamentDetail

  def execute(user_tournament_detail, player_id) do
    unless UserTournamentDetail.is_anon_user?(player_id) do
      [player_id, user_tournament_detail]
    end
  end

end
