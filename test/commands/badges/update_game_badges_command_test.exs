defmodule K2pokerIo.UpdateGameBadgesCommandTest do

  alias K2pokerIo.Test.Helpers
  alias K2pokerIo.Commands.Badges.UpdateGameBadgesCommand
  alias K2pokerIo.User
  alias K2pokerIo.Game
  alias K2pokerIo.Badge
  alias K2pokerIo.UserBadge
  alias K2pokerIo.Repo

  import Ecto.Query

  use K2pokerIo.DataCase, async: false

  doctest K2pokerIo.Commands.Badges.UpdateGameBadgesCommand

  setup do
    Helpers.advanced_set_up(["bob", "stu"])
  end

  test "Player wins with four jacks", context do
    badge = Repo.insert!(%Badge{
      name: "Four Jacks",
      description: "Win with four Jacks",
      image: "jacks",
      action: "4_jacks",
      group: 5,
      position: 1,
      gold: false
    })
    player1_id = User.player_id(context.player1)
    player2_id = User.player_id(context.player2)
    game_data = %K2poker.Game{
     players: [
        %K2poker.Player{id: player1_id, cards: ["Js", "Jc"], status: "new"},
        %K2poker.Player{id: player2_id, cards: ["2s", "3c"], status: "new"}
      ],
      table_cards: ["Jd", "Jh", "3d", "2c", "4h"],
      status: "finished",
      deck: [],
      result: %K2poker.GameResult{
        player_id: player1_id,
        status: "win",
        cards: ["Js", "Jc", "Jd", "Jh", "4h"],
        win_description: "four_of_a_kind",
        lose_description: "two_pair"
      }
    }
    encoded_game_data = Poison.encode!(game_data)
    game = Repo.update!(Game.changeset(context.game, %{data: encoded_game_data}))
    UpdateGameBadgesCommand.execute(game, player1_id)

    user_id = context.player1.id
    badge_id = badge.id

    user_badge = Repo.one(from ub in UserBadge, where: [user_id: ^user_id, badge_id: ^badge_id])
    assert(user_badge)
  end

  test "Player wins with four queens", context do
    badge = Repo.insert!(%Badge{
      name: "Four Queens",
      description: "Win with four Queens",
      image: "queens",
      action: "4_queens",
      group: 5,
      position: 2,
      gold: false
    })
    player1_id = User.player_id(context.player1)
    player2_id = User.player_id(context.player2)
    game_data = %K2poker.Game{
     players: [
        %K2poker.Player{id: player1_id, cards: ["Qs", "Qc"], status: "new"},
        %K2poker.Player{id: player2_id, cards: ["2s", "3c"], status: "new"}
      ],
      table_cards: ["Qd", "Qh", "3d", "2c", "4h"],
      status: "finished",
      deck: [],
      result: %K2poker.GameResult{
        player_id: player1_id,
        status: "win",
        cards: ["Qs", "Qc", "Qd", "Qh", "4h"],
        win_description: "four_of_a_kind",
        lose_description: "two_pair"
      }
    }
    encoded_game_data = Poison.encode!(game_data)
    game = Repo.update!(Game.changeset(context.game, %{data: encoded_game_data}))
    UpdateGameBadgesCommand.execute(game, player1_id)

    user_id = context.player1.id
    badge_id = badge.id

    user_badge = Repo.one(from ub in UserBadge, where: [user_id: ^user_id, badge_id: ^badge_id])
    assert(user_badge)
  end

  test "Player wins with four kings", context do
    badge = Repo.insert!(%Badge{
      name: "Four Kings",
      description: "Win with four Kings",
      image: "kings",
      action: "4_kings",
      group: 5,
      position: 3,
      gold: false
    })

    player1_id = User.player_id(context.player1)
    player2_id = User.player_id(context.player2)
    game_data = %K2poker.Game{
     players: [
        %K2poker.Player{id: player1_id, cards: ["Ks", "Kc"], status: "new"},
        %K2poker.Player{id: player2_id, cards: ["2s", "3c"], status: "new"}
      ],
      table_cards: ["Kd", "Kh", "3d", "2c", "4h"],
      status: "finished",
      deck: [],
      result: %K2poker.GameResult{
        player_id: player1_id,
        status: "win",
        cards: ["Ks", "Kc", "Kd", "Kh", "4h"],
        win_description: "four_of_a_kind",
        lose_description: "two_pair"
      }
    }
    encoded_game_data = Poison.encode!(game_data)
    game = Repo.update!(Game.changeset(context.game, %{data: encoded_game_data}))
    UpdateGameBadgesCommand.execute(game, player1_id)

    user_id = context.player1.id
    badge_id = badge.id

    user_badge = Repo.one(from ub in UserBadge, where: [user_id: ^user_id, badge_id: ^badge_id])
    assert(user_badge)
  end

  test "Player wins with four aces", context do
    badge = Repo.insert!(%Badge{
      name: "Four Aces",
      description: "Win with four Aces",
      image: "aces",
      action: "4_aces",
      group: 5,
      position: 4,
      gold: false
    })
    player1_id = User.player_id(context.player1)
    player2_id = User.player_id(context.player2)
    game_data = %K2poker.Game{
     players: [
        %K2poker.Player{id: player1_id, cards: ["As", "Ac"], status: "new"},
        %K2poker.Player{id: player2_id, cards: ["2s", "3c"], status: "new"}
      ],
      table_cards: ["Ad", "Ah", "3d", "2c", "4h"],
      status: "finished",
      deck: [],
      result: %K2poker.GameResult{
        player_id: player1_id,
        status: "win",
        cards: ["As", "Ac", "Ad", "Ah", "4h"],
        win_description: "four_of_a_kind",
        lose_description: "two_pair"
      }
    }
    encoded_game_data = Poison.encode!(game_data)
    game = Repo.update!(Game.changeset(context.game, %{data: encoded_game_data}))
    UpdateGameBadgesCommand.execute(game, player1_id)

    user_id = context.player1.id
    badge_id = badge.id

    user_badge = Repo.one(from ub in UserBadge, where: [user_id: ^user_id, badge_id: ^badge_id])
    assert(user_badge)
  end

  test "Player wins with a low straight", context do
    badge = Repo.insert!(%Badge{
      name: "Low Straight",
      description: "Win with a really low straight (A2345)",
      image: "low-straight",
      action: "low_straight",
      group: 3,
      position: 1,
      gold: false
    })

    player1_id = User.player_id(context.player1)
    player2_id = User.player_id(context.player2)
    game_data = %K2poker.Game{
     players: [
        %K2poker.Player{id: player1_id, cards: ["As", "2c"], status: "new"},
        %K2poker.Player{id: player2_id, cards: ["5s", "4c"], status: "new"}
      ],
      table_cards: ["Ad", "Ah", "3d", "5c", "4h"],
      status: "finished",
      deck: [],
      result: %K2poker.GameResult{
        player_id: player1_id,
        status: "win",
        cards: ["As", "2c", "3d", "4h", "5c"],
        win_description: "straight",
        lose_description: "two_pair"
      }
    }
    encoded_game_data = Poison.encode!(game_data)
    game = Repo.update!(Game.changeset(context.game, %{data: encoded_game_data}))
    UpdateGameBadgesCommand.execute(game, player1_id)

    user_id = context.player1.id
    badge_id = badge.id

    user_badge = Repo.one(from ub in UserBadge, where: [user_id: ^user_id, badge_id: ^badge_id])
    assert(user_badge)
  end

  test "Player wins with a high straight", context do

    badge = Repo.insert!(%Badge{
      name: "High Straight",
      description: "Win with a really high straight (TJQKA)",
      image: "high-straight",
      action: "high_straight",
      group: 3,
      position: 2,
      gold: false
    })

    player1_id = User.player_id(context.player1)
    player2_id = User.player_id(context.player2)
    game_data = %K2poker.Game{
     players: [
        %K2poker.Player{id: player1_id, cards: ["As", "Tc"], status: "new"},
        %K2poker.Player{id: player2_id, cards: ["5s", "4c"], status: "new"}
      ],
      table_cards: ["Kd", "Qh", "Jd", "5c", "4h"],
      status: "finished",
      deck: [],
      result: %K2poker.GameResult{
        player_id: player1_id,
        status: "win",
        cards: ["Tc", "Jd", "Qh", "Kd", "As"],
        win_description: "straight",
        lose_description: "two_pair"
      }
    }
    encoded_game_data = Poison.encode!(game_data)
    game = Repo.update!(Game.changeset(context.game, %{data: encoded_game_data}))
    UpdateGameBadgesCommand.execute(game, player1_id)

    user_id = context.player1.id
    badge_id = badge.id

    user_badge = Repo.one(from ub in UserBadge, where: [user_id: ^user_id, badge_id: ^badge_id])
    assert(user_badge)
  end

  test "Player wins with a straight flush", context do

    badge = Repo.insert!(%Badge{
      name: "Straight Flush",
      description: "Win with a straight flush",
      image: "straight-flush",
      action: "straight_flush",
      group: 3,
      position: 3,
      gold: false
    })

    player1_id = User.player_id(context.player1)
    player2_id = User.player_id(context.player2)
    game_data = %K2poker.Game{
     players: [
        %K2poker.Player{id: player1_id, cards: ["3c", "6c"], status: "new"},
        %K2poker.Player{id: player2_id, cards: ["5s", "4d"], status: "new"}
      ],
      table_cards: ["Kd", "Qh", "4c", "5c", "7c"],
      status: "finished",
      deck: [],
      result: %K2poker.GameResult{
        player_id: player1_id,
        status: "win",
        cards: ["3c", "4c", "5c", "6c", "7c"],
        win_description: "straight_flush",
        lose_description: "two_pair"
      }
    }
    encoded_game_data = Poison.encode!(game_data)
    game = Repo.update!(Game.changeset(context.game, %{data: encoded_game_data}))
    UpdateGameBadgesCommand.execute(game, player1_id)

    user_id = context.player1.id
    badge_id = badge.id

    user_badge = Repo.one(from ub in UserBadge, where: [user_id: ^user_id, badge_id: ^badge_id])
    assert(user_badge)
  end

  test "Player wins with a royal flush", context do

    badge = Repo.insert!(%Badge{
      name: "Royal Flush",
      description: "Win with a royal flush",
      image: "royal-flush",
      action: "royal_flush",
      group: 3,
      position: 4,
      gold: false
    })

    player1_id = User.player_id(context.player1)
    player2_id = User.player_id(context.player2)
    game_data = %K2poker.Game{
     players: [
        %K2poker.Player{id: player1_id, cards: ["Ac", "Tc"], status: "new"},
        %K2poker.Player{id: player2_id, cards: ["5s", "4d"], status: "new"}
      ],
      table_cards: ["Kc", "Jc", "Qc", "5c", "7c"],
      status: "finished",
      deck: [],
      result: %K2poker.GameResult{
        player_id: player1_id,
        status: "win",
        cards: ["Tc", "Jc", "Qc", "Kc", "Ac"],
        win_description: "royal_flush",
        lose_description: "two_pair"
      }
    }
    encoded_game_data = Poison.encode!(game_data)
    game = Repo.update!(Game.changeset(context.game, %{data: encoded_game_data}))
    UpdateGameBadgesCommand.execute(game, player1_id)

    user_id = context.player1.id
    badge_id = badge.id

    user_badge = Repo.one(from ub in UserBadge, where: [user_id: ^user_id, badge_id: ^badge_id])
    assert(user_badge)
  end

  test "Player wins with a hearts ace flush", context do

    badge = Repo.insert!(%Badge{
      name: "Hearts",
      description: "Win with an Ace Flush (Hearts)",
      image: "hearts",
      action: "hearts_flush",
      group: 4,
      position: 1,
      gold: false
    })

    player1_id = User.player_id(context.player1)
    player2_id = User.player_id(context.player2)
    game_data = %K2poker.Game{
     players: [
        %K2poker.Player{id: player1_id, cards: ["Ah", "Th"], status: "new"},
        %K2poker.Player{id: player2_id, cards: ["5s", "7d"], status: "new"}
      ],
      table_cards: ["3h", "6h", "8h", "5c", "7c"],
      status: "finished",
      deck: [],
      result: %K2poker.GameResult{
        player_id: player1_id,
        status: "win",
        cards: ["Ah", "Th", "8h", "6h", "3h"],
        win_description: "flush",
        lose_description: "two_pair"
      }
    }
    encoded_game_data = Poison.encode!(game_data)
    game = Repo.update!(Game.changeset(context.game, %{data: encoded_game_data}))
    UpdateGameBadgesCommand.execute(game, player1_id)

    user_id = context.player1.id
    badge_id = badge.id

    user_badge = Repo.one(from ub in UserBadge, where: [user_id: ^user_id, badge_id: ^badge_id])
    assert(user_badge)
  end

  test "Player wins with a clubs ace flush", context do

    badge = Repo.insert!(%Badge{
      name: "Clubs",
      description: "Win with an Ace Flush (Clubs)",
      image: "clubs",
      action: "clubs_flush",
      group: 4,
      position: 2,
      gold: false
    })

    player1_id = User.player_id(context.player1)
    player2_id = User.player_id(context.player2)
    game_data = %K2poker.Game{
     players: [
        %K2poker.Player{id: player1_id, cards: ["Ac", "Tc"], status: "new"},
        %K2poker.Player{id: player2_id, cards: ["5s", "7d"], status: "new"}
      ],
      table_cards: ["3c", "6c", "8c", "5d", "7c"],
      status: "finished",
      deck: [],
      result: %K2poker.GameResult{
        player_id: player1_id,
        status: "win",
        cards: ["Ac", "Tc", "8c", "6c", "3c"],
        win_description: "flush",
        lose_description: "two_pair"
      }
    }
    encoded_game_data = Poison.encode!(game_data)
    game = Repo.update!(Game.changeset(context.game, %{data: encoded_game_data}))
    UpdateGameBadgesCommand.execute(game, player1_id)

    user_id = context.player1.id
    badge_id = badge.id

    user_badge = Repo.one(from ub in UserBadge, where: [user_id: ^user_id, badge_id: ^badge_id])
    assert(user_badge)
  end

  test "Player wins with a diamonds ace flush", context do

    badge = Repo.insert!(%Badge{
      name: "Diamonds",
      description: "Win with an Ace Flush (Diamonds)",
      image: "diamonds",
      action: "diamonds_flush",
      group: 4,
      position: 3,
      gold: false
    })

    player1_id = User.player_id(context.player1)
    player2_id = User.player_id(context.player2)
    game_data = %K2poker.Game{
     players: [
        %K2poker.Player{id: player1_id, cards: ["Ad", "Td"], status: "new"},
        %K2poker.Player{id: player2_id, cards: ["5s", "7d"], status: "new"}
      ],
      table_cards: ["3d", "6d", "8d", "5h", "7c"],
      status: "finished",
      deck: [],
      result: %K2poker.GameResult{
        player_id: player1_id,
        status: "win",
        cards: ["Ad", "Td", "8d", "6d", "3d"],
        win_description: "flush",
        lose_description: "two_pair"
      }
    }
    encoded_game_data = Poison.encode!(game_data)
    game = Repo.update!(Game.changeset(context.game, %{data: encoded_game_data}))
    UpdateGameBadgesCommand.execute(game, player1_id)

    user_id = context.player1.id
    badge_id = badge.id

    user_badge = Repo.one(from ub in UserBadge, where: [user_id: ^user_id, badge_id: ^badge_id])
    assert(user_badge)
  end

  test "Player wins against aces (cracked aces)", context do

    badge = Repo.insert!(%Badge{
      name: "Cracked Aces",
      description: "Beat a pair of Aces",
      image: "cracked-aces",
      action: "cracked_aces",
      group: 2,
      position: 2,
      gold: false
    })

    player1_id = User.player_id(context.player1)
    player2_id = User.player_id(context.player2)
    game_data = %K2poker.Game{
     players: [
        %K2poker.Player{id: player1_id, cards: ["Jc", "Tc"], status: "new"},
        %K2poker.Player{id: player2_id, cards: ["As", "Ad"], status: "new"}
      ],
      table_cards: ["9s", "7s", "8s", "5h", "7c"],
      status: "finished",
      deck: [],
      result: %K2poker.GameResult{
        player_id: player1_id,
        status: "win",
        cards: ["Jc", "Tc", "9s", "8s", "7s"],
        win_description: "straight",
        lose_description: "two_pair"
      }
    }
    encoded_game_data = Poison.encode!(game_data)
    game = Repo.update!(Game.changeset(context.game, %{data: encoded_game_data}))
    UpdateGameBadgesCommand.execute(game, player1_id)

    user_id = context.player1.id
    badge_id = badge.id

    user_badge = Repo.one(from ub in UserBadge, where: [user_id: ^user_id, badge_id: ^badge_id])
    assert(user_badge)
  end

  @tag :skip
  test "Player wins with cards K2 in their hand", context do

    badge = Repo.insert!(%Badge{
      name: "K2 Hand",
      description: "Win a hand with K2",
      image: "k2-cards",
      action: "k2_cards",
      group: 2,
      position: 1,
      gold: false
    })

    player1_id = User.player_id(context.player1)
    player2_id = User.player_id(context.player2)
    game_data = %K2poker.Game{
     players: [
        %K2poker.Player{id: player1_id, cards: ["2d", "Kc"], status: "new"},
        %K2poker.Player{id: player2_id, cards: ["As", "5d"], status: "new"}
      ],
      table_cards: ["Ks", "2s", "Kh", "5h", "7c"],
      status: "finished",
      deck: [],
      result: %K2poker.GameResult{
        player_id: player1_id,
        status: "win",
        cards: ["Ks", "Kc", "Kh", "2s", "2d"],
        win_description: "full_house",
        lose_description: "two_pair"
      }
    }
    encoded_game_data = Poison.encode!(game_data)
    game = Repo.update!(Game.changeset(context.game, %{data: encoded_game_data}))
    UpdateGameBadgesCommand.execute(game, player1_id)

    user_id = context.player1.id
    badge_id = badge.id

    user_badge = Repo.one(from ub in UserBadge, where: [user_id: ^user_id, badge_id: ^badge_id])
    assert(user_badge)
  end

end
