# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     K2pokerIo.Repo.insert!(%K2pokerIo.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias K2pokerIo.Repo
alias K2pokerIo.Tournament
alias K2pokerIo.Badge
import Ecto.Query

unless Repo.one(from t in Tournament, where: t.default_tournament == true) do
  Repo.insert!(%Tournament{
    name: "K2 Summit",
    description: "K2 Summit is the big one, play against everyone in this free and open tournament, always available.",
    default_tournament: true,
    private: false,
    finished: false,
    bots: true,
    tournament_type: "tournament",
    lose_type: "all",
    starting_chips: 1,
    max_score: 1048576,
    image: "/images/tournaments/k2-icon.svg"
  })
end

Repo.insert!(%Badge{
  name: "My Profile",
  description: "Update your Bio",
  action: "update_bio",
  image: "profile",
  group: 1,
  position: 1,
  gold: false
})

Repo.insert!(%Badge{
  name: "Friends",
  description: "Make 5 friends",
  action: "5_friends",
  image: "friends",
  group: 1,
  position: 2,
  gold: false
})

Repo.insert!(%Badge{
  name: "Chat",
  description: "Start a converstion, (5 or more chats)",
  action: "5_chats",
  image: "chat",
  group: 1,
  position: 3,
  gold: false
})

Repo.insert!(%Badge{
  name: "Social Media Connect",
  description: "Connect a social media account",
  action: "social_connect",
  image: "social",
  group: 1,
  position: 4,
  gold: false
})

Repo.insert!(%Badge{
  name: "Party Animal",
  description: "Collect all the Social Badges",
  action: "complete_group",
  image: "gold-phone",
  group: 1,
  position: 5,
  gold: true
})

Repo.insert!(%Badge{
  name: "K2 Hand",
  description: "Win a hand with K2",
  image: "k2-cards",
  action: "k2_cards",
  group: 2,
  position: 1,
  gold: false
})

Repo.insert!(%Badge{
  name: "Cracked Aces",
  description: "Beat a pair of Aces",
  image: "cracked-aces",
  action: "cracked_aces",
  group: 2,
  position: 2,
  gold: false
})

Repo.insert!(%Badge{
  name: "Hill Climber",
  description: "Reach 1024 in K2 Summit",
  image: "hill-climber",
  action: "hill_climber",
  group: 2,
  position: 3,
  gold: false
})

Repo.insert!(%Badge{
  name: "High Flyer",
  description: "Reach 32768 in K2 Summit",
  image: "high-flyer",
  action: "high_flyer",
  group: 2,
  position: 4,
  gold: false
})

Repo.insert!(%Badge{
  name: "Top Dog",
  description: "Collect all the Game Badges",
  action: "complete_group",
  image: "top-dog",
  group: 2,
  position: 5,
  gold: true
})

Repo.insert!(%Badge{
  name: "Low Straight",
  description: "Win with a really low straight (A2345)",
  image: "low-straight",
  action: "low_straight",
  group: 3,
  position: 1,
  gold: false
})

Repo.insert!(%Badge{
  name: "High Straight",
  description: "Win with a really high straight (TJQKA)",
  image: "high-straight",
  action: "high_straight",
  group: 3,
  position: 2,
  gold: false
})

Repo.insert!(%Badge{
  name: "Straight Flush",
  description: "Win with a straight flush",
  image: "straight-flush",
  action: "straight_flush",
  group: 3,
  position: 3,
  gold: false
})

Repo.insert!(%Badge{
  name: "Royal Flush",
  description: "Win with a royal flush",
  image: "royal-flush",
  action: "royal_flush",
  group: 3,
  position: 4,
  gold: false
})

Repo.insert!(%Badge{
  name: "Tiger Shark",
  description: "Collect all the 'Straight' Badges",
  action: "complete_group",
  image: "shark",
  group: 3,
  position: 5,
  gold: true
})

Repo.insert!(%Badge{
  name: "Hearts",
  description: "Win with an Ace Flush (Hearts)",
  image: "hearts",
  action: "hearts_flush",
  group: 4,
  position: 1,
  gold: false
})

Repo.insert!(%Badge{
  name: "Clubs",
  description: "Win with an Ace Flush (Clubs)",
  image: "clubs",
  action: "clubs_flush",
  group: 4,
  position: 2,
  gold: false
})

Repo.insert!(%Badge{
  name: "Diamonds",
  description: "Win with an Ace Flush (Diamonds)",
  image: "diamonds",
  action: "diamonds_flush",
  group: 4,
  position: 3,
  gold: false
})

Repo.insert!(%Badge{
  name: "Spades",
  description: "Win with an Ace Flush (Spades)",
  image: "spades",
  action: "spades_flush",
  group: 4,
  position: 4,
  gold: false
})

Repo.insert!(%Badge{
  name: "Flush Master",
  description: "Collect all the 'Flush' Badges",
  action: "complete_group",
  image: "flush-master",
  group: 4,
  position: 5,
  gold: true
})

Repo.insert!(%Badge{
  name: "Four Jacks",
  description: "Win with four Jacks",
  image: "jacks",
  action: "4_jacks",
  group: 5,
  position: 1,
  gold: false
})

Repo.insert!(%Badge{
  name: "Four Queens",
  description: "Win with four Queens",
  image: "queens",
  action: "4_queens",
  group: 5,
  position: 2,
  gold: false
})

Repo.insert!(%Badge{
  name: "Four Kings",
  description: "Win with four Kings",
  image: "kings",
  action: "4_kings",
  group: 5,
  position: 3,
  gold: false
})

Repo.insert!(%Badge{
  name: "Four Aces",
  description: "Win with four Aces",
  image: "aces",
  action: "4_aces",
  group: 5,
  position: 4,
  gold: false
})

Repo.insert!(%Badge{
  name: "Fantastic Fours",
  description: "Collect all the 'Four-of-a-kind' Badges",
  action: "complete_group",
  image: "fantastic-fours",
  group: 5,
  position: 5,
  gold: true
})

Repo.insert!(%Badge{
  name: "Duel Winner",
  description: "Win a Duel",
  image: "duel",
  action: "duel_winner",
  group: 6,
  position: 1,
  gold: false
})

Repo.insert!(%Badge{
  name: "Private Tournament Winner",
  description: "Win a Private Tournament",
  image: "private",
  action: "private_winner",
  group: 6,
  position: 2,
  gold: false
})

Repo.insert!(%Badge{
  name: "K2 Summit Winner",
  description: "Win the K2 Summit Tournament",
  image: "k2-tournament",
  action: "k2_winner",
  group: 6,
  position: 3,
  gold: false
})

Repo.insert!(%Badge{
  name: "Crypto Tournament",
  description: "Win a Crypto Tournament",
  image: "monero",
  action: "crypto_winner",
  group: 6,
  position: 4,
  gold: false
})

Repo.insert!(%Badge{
  name: "Tournament VIP",
  description: "Collect all the Tournament Badges",
  action: "complete_group",
  image: "vip",
  group: 6,
  position: 5,
  gold: true
})
