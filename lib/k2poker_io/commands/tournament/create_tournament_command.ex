defmodule K2pokerIo.Commands.Tournament.CreateTournamentCommand do

  alias K2pokerIo.Repo
  alias K2pokerIo.Tournament
  alias K2pokerIo.Invitation
  alias K2pokerIo.User
  alias K2pokerIo.Queries.Friends.FriendsQuery
  alias K2pokerIo.Queries.Tournaments.PlayersUnfinishedTournamentsQuery

  def execute(current_user, params) do
    case create_tournament(current_user, params) do
      {:ok, tournament} -> invite_friends(tournament, current_user, params)
      {:error, error} -> {:error, error}
      true -> {:error, "Unable to create the tournament"}
    end
  end

  defp create_tournament(current_user, params) do
    if has_unfinished_tournament_with_opponent?(current_user, params) do
      {:error, "You already have a duel open with this player, please finish the duel or choose another opponent"}
    else
      changeset = case params["game_type"] do
       "tournament" -> tournament_params(current_user, params)
       "duel"       -> duel_params(current_user, params)
      end
      Repo.insert(changeset)
    end
  end

  defp has_unfinished_tournament_with_opponent?(current_user, params) do
    if params["game_type"] == "duel" do
      opponent_unfinished_duels = unfinished_duels(List.first(params["friend_ids"]))
      Enum.any?(unfinished_duels(current_user.id), fn (tournament_id) -> Enum.member?(opponent_unfinished_duels, tournament_id) end)
    else
      false
    end
  end

  defp unfinished_duels(user_id) do
    PlayersUnfinishedTournamentsQuery.unfinished_duels(user_id)
  end

  defp tournament_params(current_user, params) do
    %Tournament{
      name: params["name"],
      description: params["description"],
      default_tournament: false,
      finished: false,
      private: true,
      user_id: current_user.id,
      type: "tournament",
      image: "/images/tournament/private.svg",
      lose_type: "all",
      starting_chips: 1,
      max_score: max_score(params["max_score"]),
      bots: true
    }
  end

  defp max_score(max_score) do
    max_score = max_score || "1048576"
    {max_score, _} = Integer.parse(max_score)
    if Enum.member?(available_scores, max_score), do: max_score, else: 1048576
  end

  defp available_scores do
    [64, 128, 256, 512, 1024, 2048, 4096, 8192, 16384,131072,1048576]
  end

  defp duel_params(current_user, params) do
    opponent_id = List.first(params["friend_ids"])
    opponent = Repo.get(User, opponent_id)
    %Tournament{
      name: params["name"],
      description: "It's a duel... Rags or Riches!",
      default_tournament: false,
      finished: false,
      private: true,
      type: "duel",
      user_id: current_user.id,
      lose_type: "half",
      image: "/images/tournament/duel.svg",
      starting_chips: 1024,
      max_score: 1048576,
      bots: false
    }
  end

  defp invite_friends(tournament, current_user, params) do
    filter_valid_friends(current_user.id, params)
    |> Enum.each( fn user_id -> create_invitation(tournament.id, user_id, false) end)
    create_invitation(tournament.id, current_user.id, true)
    {:ok, tournament}
  end

  defp create_invitation(tournament_id, user_id, accepted) do
    Repo.insert(%Invitation{tournament_id: tournament_id, user_id: user_id, accepted: accepted})
  end

  defp filter_valid_friends(current_user_id, params) do
    valid_friend_ids = FriendsQuery.ids(current_user_id)
    friend_ids = params["friend_ids"]
    Enum.filter(friend_ids, fn friend_id -> Enum.any?(valid_friend_ids, fn x -> x == friend_id end) end)
  end

end
