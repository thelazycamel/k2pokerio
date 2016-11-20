defmodule K2pokerIo.Fixtures.UserTournamentDetailFixture do

  alias K2pokerIo.Repo
  alias K2pokerIo.UserTournamentDetail

  def create(%{username: username, tournament_id: tournament_id}) do
    detail = %{player_id: anon_player_id(username), username: username, tournament_id: tournament_id, current_score: 1, rebuys: [0]}
    changeset = UserTournamentDetail.changeset(%UserTournamentDetail{}, detail)
    Repo.insert!(changeset)
  end

  defp anon_player_id(name) do
    "anon|" <> name <> random_hash(32)
  end

  defp random_hash(length) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length) |> String.replace("|", "-")
  end

end
