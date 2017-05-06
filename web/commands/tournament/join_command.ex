defmodule K2pokerIo.Commands.Tournament.JoinCommand do

  alias K2pokerIo.UserTournamentDetail
  alias K2pokerIo.Repo
  alias K2pokerIo.User
  import Ecto
  import Ecto.Query

  def execute(current_user, tournament_id) do
    if user_has_access?(current_user, tournament_id) do
      find_or_create_user_tournament_detail(current_user, tournament_id)
    else
      {:error}
    end
  end

  #TODO check tournament exists is open and avaliable to user
  #
  def user_has_access?(current_user, tournament_id) do
    current_user
  end

  #TODO when we create tournaments, set the current_score to the tournament starting_score value, and rebuys etc
  #
  def find_or_create_user_tournament_detail(current_user, tournament_id) do
    player_id = User.player_id(current_user)
    if utd = Repo.get_by(UserTournamentDetail, player_id: player_id, tournament_id: tournament_id) do
      {:ok, utd_id: utd.id}
    else
      detail = %{player_id: player_id, username: current_user.username, tournament_id: tournament_id, current_score: 1, rebuys: [0]}
      changeset = UserTournamentDetail.changeset(%UserTournamentDetail{}, detail)
      case Repo.insert(changeset) do
        {:ok, utd} ->
          {:ok, utd_id: utd.id}
        {:error, _} ->
          {:error}
      end
    end
  end

end
