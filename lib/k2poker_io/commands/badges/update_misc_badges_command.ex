defmodule K2pokerIo.Commands.Badges.UpdateMiscBadgesCommand do

  alias K2pokerIo.UserTournamentDetail
  alias K2pokerIo.User
  alias K2pokerIo.Commands.Badges.AddUserBadgeCommand

  def execute(action, player_id, opts) do
    if UserTournamentDetail.is_user?(player_id) do
      add_badge(action, player_id, opts)
    else
      {:ok, []}
    end
  end

  defp add_badge(action, player_id, opts) do
    {:user, user_id} = User.get_id(player_id)
    {:ok, badges} = AddUserBadgeCommand.execute(action, user_id)
    if (Enum.any?(badges) && opts[:broadcast]) do
      broadcast_to_channel(badges, player_id, opts)
    end
    {:ok, badges}
  end

  defp broadcast_to_channel(badges, player_id, opts) do
    payload = %{player_id: player_id, badges: badges}
    K2pokerIoWeb.Endpoint.broadcast!("#{opts[:broadcast]}:#{opts[:id]}", "#{opts[:broadcast]}:badge_awarded", payload)
  end

end
