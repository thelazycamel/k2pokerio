defmodule K2pokerIo.ChatTest do

  use K2pokerIo.DataCase, async: false

  alias K2pokerIo.Chat
  alias K2pokerIo.Test.Helpers
  alias K2pokerIo.Repo

  doctest K2pokerIo.Chat

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

  test "changeset should validate user_id", context do
    params = %{tournament_id: context.tournament.id, comment: "Test Comment"}
    changeset = Chat.changeset(%Chat{}, params)
    refute(changeset.valid?)
    {text, [error]} = changeset.errors[:user_id]
    assert(text == "can't be blank")
    assert(error == {:validation, :required})
  end

  test "changeset should validate tournament_id", context do
    params = %{user_id: context.user_id, comment: "Test Comment"}
    changeset = Chat.changeset(%Chat{}, params)
    refute(changeset.valid?)
    {text, [error]} = changeset.errors[:tournament_id]
    assert(text == "can't be blank")
    assert(error == {:validation, :required})
  end

  test "changeset should validate comment", context do
    params = %{user_id: context.user_id, tournament_id: context.tournament.id, comment: ""}
    changeset = Chat.changeset(%Chat{}, params)
    refute(changeset.valid?)
    {text, [error]} = changeset.errors[:comment]
    assert(text == "can't be blank")
    assert(error == {:validation, :required})
  end

  test "get_ten", context do
    tournament = context.tournament
    comments = Chat.get_ten_json(tournament.id, context.user_id)
    assert Enum.count(comments) == 10
    first_comment = List.first(comments)
    last_comment = List.last(comments)
    assert first_comment[:username] == "stu"
    assert last_comment[:comment] == "11th comment for #{tournament.name}"
    assert first_comment[:comment] == "2nd comment for #{tournament.name}"
  end

end
