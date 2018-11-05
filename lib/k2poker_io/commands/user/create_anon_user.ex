defmodule K2pokerIo.Commands.User.CreateAnonUser do

  alias K2pokerIo.Repo
  alias K2pokerIo.UserTournamentDetail
  alias K2pokerIo.Tournament

  def execute(anon_username) do
    set_name_or_anon(anon_username)
    |> clean_username()
    |> create_user_tournament_detail()
  end

  defp set_name_or_anon(anon_username) do
    anon_username = case anon_username do
      "" -> "anon"
      nil -> "anon"
      _ -> anon_username
    end
  end

  defp clean_username(anon_username) do
    String.replace(anon_username, ~r/\W/, " ")
  end

  defp generate_anon_player_id(anon_username) do
    anon_username = String.replace(anon_username, " ", "")
    "anon|" <> anon_username <> random_hash(32)
  end

  # generate a random_hash, replace any | so we can enable splitting by them in the player_id
  defp random_hash(length) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length) |> String.replace("|", "-")
  end

  defp create_user_tournament_detail(anon_username) do
    changeset = UserTournamentDetail.changeset(%UserTournamentDetail{}, utd_params(anon_username))
    Repo.insert(changeset)
  end

  defp utd_params(anon_username) do
    %{
      player_id: generate_anon_player_id(anon_username),
      user_id: nil,
      username: anon_username,
      tournament_id: Tournament.default.id,
      current_score: 1,
      rebuys: [0]
      }
  end

end
