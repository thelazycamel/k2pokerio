defmodule K2pokerIo.Commands.Tournament.CreateTournamentCommand do

  alias K2pokerIo.Repo
  alias K2pokerIo.Tournament
  alias K2pokerIo.UserTournamentDetail
  alias K2pokerIo.Invitation
  alias K2pokerIo.User
  alias K2pokerIo.Queries.Friends.FriendsQuery

  import Ecto.Query

  def execute(current_user, params) do
    case create_tournament(current_user, params) do
      {:ok, tournament} -> invite_friends(tournament, current_user, params)
      true -> {:error, "Unable to create the tournament"}
    end
  end

  defp create_tournament(current_user, params) do
    changeset = case params["game_type"] do
     "tournament" -> tournament_params(current_user, params)
     "duel"       -> duel_params(current_user, params)
    end
    if params["game_type"] == "duel" do
      opponent_id = List.first(extract_friend_ids_from_params(params))
      # collect the tournament ids utds by player ids where tournament is duel
      # and finished is false
      # something like
      # where utd.player_id in [opp.player_id, current_user.player_id],
      # utd.joins.tournaments where tournament is duel and finished is false
      # collect tournament_ids
      # then check if any duplicates tournament_ids,
      # means both users in same open tournament already
      Repo.insert(changeset)
    else
      Repo.insert(changeset)
    end
  end

  defp tournament_params(current_user, params) do
    %Tournament{
      name: params["name"],
      default_tournament: false,
      finished: false,
      private: true,
      user_id: current_user.id,
      lose_type: "all",
      starting_chips: 1,
      max_score: 1048576,
      bots: true
    }
  end

  defp duel_params(current_user, params) do
    opponent_id = List.first(extract_friend_ids_from_params(params))
    opponent = Repo.get(User, opponent_id)
    %Tournament{
      name: "#{current_user.username} v #{opponent.username}",
      default_tournament: false,
      finished: false,
      private: true,
      user_id: current_user.id,
      lose_type: "half",
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
    friend_ids = extract_friend_ids_from_params(params)
    Enum.filter(friend_ids, fn friend_id -> Enum.any?(valid_friend_ids, fn x -> x == friend_id end) end)
  end

  defp extract_friend_ids_from_params(params) do
    Enum.map(String.split(params["friend_ids"], ","), fn (n) -> String.to_integer(n) end)
  end

end
