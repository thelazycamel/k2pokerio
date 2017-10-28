defmodule K2pokerIo.Decorators.AnonUserProfileDecorator do

  alias K2pokerIo.Repo
  alias K2pokerIo.UserTournamentDetail

  import Ecto.Query

  def decorate(opponent_id) do
    opponent = get_opponent(opponent_id)
    %{
      id:       nil,
      username: opponent.username,
      opponent: :anon,
      blurb:    "Meh, just an anonymous fish",
      image:    "fish.png",
      friend:   :na
      }
  end

  defp get_opponent(opponent_id) do
    Repo.one(
      from u in UserTournamentDetail,
      where: u.player_id == ^opponent_id,
      select: %{id: u.id, username: u.username}
    )
  end

end
