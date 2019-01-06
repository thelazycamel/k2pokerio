defmodule K2pokerIo.Commands.Badges.UpdateMiscBadgesCommand do

  alias K2pokerIo.UserTournamentDetail
  alias K2pokerIo.User
  alias K2pokerIo.Commands.Badges.AddUserBadgeCommand

  def execute(action, player_id) do
    if UserTournamentDetail.is_user?(player_id) do
      add_badge(action, player_id)
    else
      {:ok, []}
    end
  end

  defp add_badge(action, player_id) do
    {:user, user_id} = User.get_id(player_id)
    AddUserBadgeCommand.execute(action, user_id)
  end

end
