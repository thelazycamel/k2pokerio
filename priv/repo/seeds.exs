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

#Repo.insert!(%Tournament{name: "K2 Summit Ascent", default_tournament: true, private: false, finished: false})

