defmodule K2pokerIo.AnonUser do

  alias K2pokerIo.Repo
  alias K2pokerIo.UserTournamentDetail
  alias K2pokerIo.Tournament

  # Creates a user_tournament_detail for a non-signed in user

  def create(anon_username) do
    anon_username = String.replace(anon_username, ~r/\W/, " ") #dumb security to remove all non-word chrs
    player_id = generate_anon_player_id(anon_username)
    create_user_tournament_detail(anon_username, player_id)
  end

  defp generate_anon_player_id(anon_username) do
    anon_username = String.replace(anon_username, " ", "")
    "anon|" <> anon_username <> random_hash(32)
  end

  # generate a random_hash, replace any | so we can enable splitting by them in the player_id
  defp random_hash(length) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length) |> String.replace("|", "-")
  end

  defp create_user_tournament_detail(username, player_id) do
    detail = %{player_id: player_id, username: username, tournament_id: Tournament.default.id, current_score: 1, rebuys: [0]}
    changeset = UserTournamentDetail.changeset(%UserTournamentDetail{}, detail)
    case Repo.insert(changeset) do
      {:ok, user_tournament_detail} ->
        {:ok, user_tournament_detail}
      {:error, changeset} ->
        {:error, changeset}
    end
  end

end
