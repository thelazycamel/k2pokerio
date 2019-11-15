defmodule K2pokerIo.ChatTest do

  use K2pokerIo.DataCase, async: false

  alias K2pokerIo.Chat
  alias K2pokerIo.Test.Helpers

  doctest K2pokerIo.Chat

  setup do
    user = Helpers.create_user("stu")
    tournament = Helpers.create_tournament()
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

end
