defmodule K2pokerIoWeb.BadgeController do

  use K2pokerIoWeb, :controller

  alias K2pokerIo.Queries.Badges.BadgesQuery

  def index(conn, _) do
    if current_user(conn) do
      json conn, %{badges: BadgesQuery.all_by_user(current_user(conn))}
    else
      json conn, %{badges: []}
    end
  end

  def gold_badges(conn, _) do

  end

end
