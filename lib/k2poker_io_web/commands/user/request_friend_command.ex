defmodule K2pokerIoWeb.Commands.User.RequestFriendCommand do

  alias K2pokerIo.Repo
  alias K2pokerIo.Friendship
  alias K2pokerIoWeb.Commands.User.GetFriendStatusCommand

  import Ecto.Query

  def execute(user_id, friend_id) do
    case GetFriendStatusCommand.execute(user_id, friend_id) do
      :not_friends -> create_friendship_request(user_id, friend_id)
      :pending_me -> confirm_friendship(user_id, friend_id)
      :pending_them -> :pending_them
      :friend -> :friend
      true -> :na
    end
  end

  defp create_friendship_request(user_id, friend_id) do
    detail = %{user_id: user_id, friend_id: friend_id, status: false}
    changeset = Friendship.changeset(%Friendship{}, detail)
    case Repo.insert(changeset) do
      {:ok, _} -> :pending_them
      {:error, _} -> :na
    end
  end

  defp confirm_friendship(user_id, friend_id) do
    friendship = Repo.one(from Friendship, where: fragment("user_id = ? and friend_id = ?", ^friend_id, ^user_id))
    changeset = Friendship.changeset(friendship, %{status: true})
    case Repo.update(changeset) do
      {:ok, _} -> :friend
      {:error, _} -> :na
    end
  end

end
