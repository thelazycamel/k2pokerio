defmodule K2pokerIo.InvitationControllerTest do

  use K2pokerIoWeb.ConnCase
  alias K2pokerIo.Commands.User.RequestFriendCommand
  alias K2pokerIo.Invitation
  alias K2pokerIo.User
  alias K2pokerIo.Test.Helpers
  alias K2pokerIo.Repo
  import Plug.Test

  doctest K2pokerIoWeb.InvitationController

  setup do
    player1 = Helpers.create_user("bob")
    player2 = Helpers.create_user("stu")
    tournament = Helpers.create_private_tournament(player1, "bobs tourney")
    RequestFriendCommand.execute(player1.id, player2.id)
    invitation = Repo.insert!(Invitation.changeset(
      %Invitation{}, %{ user_id: player2.id, tournament_id: tournament.id, accepted: false})
    )
    %{player1: player1, player2: player2, tournament: tournament, invitation: invitation}
  end

  test "#accept should accept the invite and redirect to the tournament", context do
    conn = init_test_session(context.conn, player_id: User.player_id(context.player2))
    response = conn
      |> get(invitation_path(conn, :accept, context.invitation.id))
      |> response(302)
    expected = ~r/href.*\/tournaments\/join\//
    assert(response =~ expected)
  end

  test "#accept should redirect to tournament index if invalid invite", context do
    conn = init_test_session(context.conn, player_id: User.player_id(context.player1))
    response = conn
      |> get(invitation_path(conn, :accept, context.invitation.id))
      |> response(302)
    expected = ~r/href="\/tournaments"/
    assert(response =~ expected)
  end

  test "#destroy should destroy the invite and return the id", context do
    conn = init_test_session(context.conn, player_id: User.player_id(context.player2))
    response = conn
      |> delete(invitation_path(conn, :delete, context.invitation.id))
      |> json_response(200)
    expected = %{"invite_id" => context.invitation.id}
    assert(response == expected)
  end

end
