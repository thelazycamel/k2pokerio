defmodule K2pokerIo.Decorators.FriendDecorator do

  def decorate(friendship, current_user_id) do
    friend = if friendship.user_id == current_user_id, do: friendship.friend, else: friendship.user
    %{
      id: friend.id,
      username: friend.username,
      image: friend.image,
      blurb: friend.blurb,
      status: status(friendship, current_user_id)
    }
  end

  def image(image) do
    if image, do: image, else: "/images/profile-images/fish.png"
  end

  def status(friendship, current_user_id) do
    if friendship do
      case friendship.status do
        true -> :friend
        _ -> pending_me_or_them(current_user_id, friendship.user_id)
      end
    else
      :not_friends
    end
  end

  defp pending_me_or_them(current_user_id, user_id) do
    if current_user_id == user_id, do: :pending_them, else: :pending_me
  end

end
