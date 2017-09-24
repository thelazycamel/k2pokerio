defmodule K2pokerIoWeb.InvitationController do

  use K2pokerIoWeb, :controller

  alias K2pokerIoWeb.Commands.Invitation.AcceptCommand
  alias K2pokerIoWeb.Commands.Invitation.DestroyCommand

  def accept(conn, %{"id" => invite_id}) do
    case AcceptCommand.execute(current_user(conn), invite_id) do
      {:ok, invite} ->
        redirect conn, to: tournament_path(conn, :join, invite.tournament_id)
      _ ->
        redirect conn, to: tournament_path(conn, :index)
    end
  end

  def destroy(conn, %{"id" => id}) do
    id = String.to_integer(id)
    DestroyCommand.execute(current_user(conn), id)
    json conn, %{invite_id: id}
  end

end
