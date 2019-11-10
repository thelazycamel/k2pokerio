defmodule K2pokerIoWeb.InvitationController do

  use K2pokerIoWeb, :controller

  alias K2pokerIo.Commands.Invitation.AcceptInvitationCommand
  alias K2pokerIo.Commands.Invitation.DestroyInvitationCommand
  alias K2pokerIo.Queries.Invitations.InvitationsQuery

  def index(conn, params) do
    if current_user(conn) do
      {invitations, pagination} = InvitationsQuery.all(current_user(conn).id, params)
      json conn, %{invitations: invitations, pagination: pagination}
    else
      json conn, %{invitations: [], pagination: {}}
    end
  end

  def count(conn, _) do
    if current_user(conn) do
      count = InvitationsQuery.count(current_user(conn).id)
      json conn, %{count: count}
    else
      json conn, %{count: 0}
    end
  end

  def accept(conn, %{"id" => invite_id}) do
    case AcceptInvitationCommand.execute(current_user(conn), invite_id) do
      {:ok, invite} ->
        redirect conn, to: Routes.tournament_path(conn, :join, invite.tournament_id)
      _ ->
        redirect conn, to: Routes.tournament_path(conn, :index)
    end
  end

  def delete(conn, %{"id" => id}) do
    id = String.to_integer(id)
    DestroyInvitationCommand.execute(current_user(conn), id)
    json conn, %{invite_id: id}
  end

end
