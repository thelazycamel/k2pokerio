defmodule K2pokerIo.InvitationController do

  use K2pokerIo.Web, :controller
  alias K2pokerIo.Commands.Invitation.AcceptCommand
  alias K2pokerIo.Commands.Invitation.DestroyCommand

  def accept(conn, %{"id" => invite_id}) do
    case AcceptCommand.execute(current_user(conn), invite_id) do
      {:ok, invite} ->
        redirect conn, to: tournament_path(conn, :join, invite.tournament_id)
      _ ->
        redirect conn, to: tournament_path(conn, :index)
    end
  end

  def destroy(conn, %{"id" => id}) do
    DestroyCommand.execute(current_user(conn), id)
    json conn, %{invite_id: id}
  end

end
