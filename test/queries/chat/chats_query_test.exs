defmodule K2pokerIo.ChatQueryTest do

  use K2pokerIo.DataCase, async: false

  alias K2pokerIo.Test.Helpers
  alias K2pokerIo.Queries.Chats.ChatsQuery

  doctest K2pokerIo.Queries.Chats.ChatsQuery

  setup do
    user = Helpers.create_user("stu")
    tournament = Helpers.create_tournament()
    Helpers.create_chat(tournament.id, user.id, "first comment for #{tournament.name}", false)
    Helpers.create_chat(tournament.id, user.id, "2nd comment for #{tournament.name}", false)
    Helpers.create_chat(tournament.id, user.id, "3rd comment for #{tournament.name}", false)
    Helpers.create_chat(tournament.id, user.id, "4th comment for #{tournament.name}", false)
    Helpers.create_chat(tournament.id, user.id, "5th comment for #{tournament.name}", false)
    Helpers.create_chat(tournament.id, user.id, "6th comment for #{tournament.name}", false)
    Helpers.create_chat(tournament.id, user.id, "7th comment for #{tournament.name}", false)
    Helpers.create_chat(tournament.id, user.id, "8th comment for #{tournament.name}", false)
    Helpers.create_chat(tournament.id, user.id, "9th comment for #{tournament.name}", false)
    Helpers.create_chat(tournament.id, user.id, "10th comment for #{tournament.name}", false)
    Helpers.create_chat(tournament.id, user.id, "11th comment for #{tournament.name}", false)
    %{tournament: tournament, user_id: user.id}
  end

  @tag :skip
  test "get_ten", context do
    tournament = context.tournament
    comments = ChatsQuery.get_ten_json(tournament.id, context.user_id)
    first_comment = List.first(comments)
    last_comment = List.last(comments)
    assert first_comment[:comment] == "2nd comment for #{tournament.name}"
    assert last_comment[:comment] == "11th comment for #{tournament.name}"
    assert Enum.count(comments) == 10
  end

end
