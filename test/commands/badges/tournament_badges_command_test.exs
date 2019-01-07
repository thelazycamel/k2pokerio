defmodule K2pokerIo.UpdateTournamentBadgesCommandTest do

  alias K2pokerIo.Test.Helpers
  alias K2pokerIo.Commands.Badges.UpdateTournamentBadgesCommand
  alias K2pokerIo.Tournament
  alias K2pokerIo.Badge
  alias K2pokerIo.UserBadge
  alias K2pokerIo.Repo

  import Ecto.Query

  use K2pokerIo.ModelCase

  doctest K2pokerIo.Commands.Badges.UpdateTournamentBadgesCommand

  setup do
    Helpers.advanced_set_up(["bob", "stu"])
  end

  test "Player wins the k2 poker tournament", context do

    badge = Repo.insert!(%Badge{
      name: "K2 Summit Winner",
      description: "Win the K2 Summit Tournament",
      image: "k2-tournament",
      action: "k2_winner",
      group: 6,
      position: 3,
      gold: false
    })

    UpdateTournamentBadgesCommand.execute(context.tournament, context.p1_utd.player_id)

    user_id = context.player1.id
    badge_id = badge.id

    user_badge = Repo.one(from ub in UserBadge, where: [user_id: ^user_id, badge_id: ^badge_id])
    assert(user_badge)
  end

  @tag :skip
  test "Player wins a crypto tournament", context do

    badge = Repo.insert!(%Badge{
      name: "Crypto Tournament",
      description: "Win a Crypto Tournament",
      image: "monero",
      action: "crypto_winner",
      group: 6,
      position: 4,
      gold: false
    })

    tournament = Repo.insert!(%Tournament{
      name: "Nano Nano",
      description: "Win Crypto -> Nano Tournament",
      default_tournament: false,
      private: false,
      finished: false,
      bots: true,
      tournament_type: "tournament",
      lose_type: "all",
      starting_chips: 1,
      max_score: 1048576,
      image: "/images/tournaments/nano.svg"
    })

    UpdateTournamentBadgesCommand.execute(tournament, context.p1_utd.player_id)

    user_id = context.player1.id
    badge_id = badge.id

    user_badge = Repo.one(from ub in UserBadge, where: [user_id: ^user_id, badge_id: ^badge_id])
    assert(user_badge)
  end

  test "Player wins a private tournament", context do

    badge = Repo.insert!(%Badge{
      name: "Private Tournament Winner",
      description: "Win a Private Tournament",
      image: "private",
      action: "private_winner",
      group: 6,
      position: 2,
      gold: false
    })

    tournament = Repo.insert!(%Tournament{
      name: "My Private tournament",
      description: "A test private tournament",
      default_tournament: false,
      private: true,
      finished: true,
      bots: true,
      tournament_type: "tournament",
      lose_type: "all",
      starting_chips: 1,
      max_score: 1048576,
      image: "/images/tournaments/private.svg"
    })

    UpdateTournamentBadgesCommand.execute(tournament, context.p1_utd.player_id)

    user_id = context.player1.id
    badge_id = badge.id

    user_badge = Repo.one(from ub in UserBadge, where: [user_id: ^user_id, badge_id: ^badge_id])
    assert(user_badge)
  end

  test "Player wins a duel", context do

    badge = Repo.insert!(%Badge{
      name: "Duel Winner",
      description: "Win a Duel",
      image: "duel",
      action: "duel_winner",
      group: 6,
      position: 1,
      gold: false
    })

    tournament = Repo.insert!(%Tournament{
      name: "player1 vs player2",
      description: "A duel",
      default_tournament: false,
      private: true,
      finished: true,
      bots: false,
      tournament_type: "duel",
      lose_type: "half",
      starting_chips: 1024,
      max_score: 1048576,
      image: "/images/tournaments/duel.svg"
    })

    UpdateTournamentBadgesCommand.execute(tournament, context.p1_utd.player_id)

    user_id = context.player1.id
    badge_id = badge.id

    user_badge = Repo.one(from ub in UserBadge, where: [user_id: ^user_id, badge_id: ^badge_id])
    assert(user_badge)
  end

end
