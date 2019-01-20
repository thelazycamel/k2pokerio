defmodule K2pokerIo.CreateCommentCommandTest do

  alias K2pokerIo.Test.Helpers
  alias K2pokerIo.Commands.Chat.CreateCommentCommand

  use K2pokerIo.ModelCase

  doctest K2pokerIo.Commands.Chat.CreateCommentCommand

  setup do
    tournament = Helpers.create_tournament()
    player1 = Helpers.create_user("bob")
    player2 = Helpers.create_user("stu")
    %{tournament: tournament, player1: player1, player2: player2}
  end

  test "it should create a comment", context do
    params = %{
      user_id: context.player1.id,
      tournament_id: context.tournament.id,
      comment: "Testing, Testing 123",
      admin: false
    }
    {:ok, response} = CreateCommentCommand.execute(params)
    assert(response.comment == "Testing, Testing 123")
  end

  test "it should fail with incorrect params", context do
    params = %{
      user_id: context.player1.id,
      tournament_id: context.tournament.id,
      comment: "",
      admin: false
    }
    {response_type, response} = CreateCommentCommand.execute(params)
    {error_message, error_type} = response.errors[:comment]
    assert(response_type == :error)
    assert(error_message == "can't be blank")
    assert(error_type == [validation: :required])
  end

  test "strips malicious code", context do
    params = %{
      user_id: context.player1.id,
      tournament_id: context.tournament.id,
      comment: "<script>something bad</script>",
      admin: false
    }
    {:ok, response} = CreateCommentCommand.execute(params)
    assert(response.comment == "something bad")
  end

end

