defmodule K2pokerIo.ChatTest do

  use K2pokerIo.ModelCase

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
    %{tournament_id: tournament.id, user_id: user.id}
  end

  test "changeset should validate user_id", context do
    params = %{tournament_id: context.tournament_id, comment: "Test Comment"}
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
    params = %{user_id: context.user_id, tournament_id: context.tournament_id, comment: ""}
    changeset = Chat.changeset(%Chat{}, params)
    refute(changeset.valid?)
    {text, [error]} = changeset.errors[:comment]
    assert(text == "can't be blank")
    assert(error == {:validation, :required})
  end

  test "get_ten", context do
    comments = Chat.get_ten_json(context.tournament_id)
    tournament = Repo.get(K2pokerIo.Tournament, context.tournament_id)
    assert Enum.count(comments) == 10
    first_comment = List.first(comments)
    assert first_comment[:username] == "stu"
    assert first_comment[:comment] == "2nd comment for #{tournament.name}"
  end

end
