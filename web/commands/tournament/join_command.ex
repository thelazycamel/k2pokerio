defmodule K2pokerIo.Commands.Tournament.JoinCommand do

  alias K2pokerIo.UserTournamentDetail
  alias K2pokerIo.Repo
  alias K2pokerIo.User
  import Ecto
  import Ecto.Query

  def execute(current_user, tournament_id) do
    delete_old_utd(current_user)
    if user_has_access?(current_user, tournament_id) do
      create_user_tournament_detail(current_user, tournament_id)
    else
      {:error}
    end
  end

  def delete_old_utd(current_user) do
    if utd = Repo.get_by(UserTournamentDetail, player_id: User.player_id(current_user)) |> Repo.preload([:game]) do
      Repo.delete(utd)
    end
  end

  #TODO check tournament exists is open and avaliable to user
  #
  def user_has_access?(current_user, tournament_id) do
    current_user
  end

  #TODO when we create tournaments, set the current_score to the tournament starting_score value, and rebuys etc
  #
  def create_user_tournament_detail(current_user, tournament_id) do
    detail = %{player_id: User.player_id(current_user), username: current_user.username, tournament_id: tournament_id, current_score: 1, rebuys: [0]}
    changeset = UserTournamentDetail.changeset(%UserTournamentDetail{}, detail)
    case Repo.insert(changeset) do
      {:ok, _} ->
        {:ok}
      {:error, _} ->
        {:error}
    end
  end

end
