defmodule K2pokerIo.Decorators.CommentDecorator do

  alias K2pokerIo.User

  def decorate(comment, player_id) do
    %{
      chat_id: comment.id,
      user_id: comment.user_id,
      username: comment.user.username,
      image: image(comment),
      comment: comment.comment,
      admin: comment.admin,
      owner: owner(comment, player_id),
      show: "comment"
     }
  end

  def owner(comment, player_id) do
    comment.user && (User.player_id(comment.user) == player_id)
  end

  def image(comment) do
    admin = comment.admin
    image = comment.user && comment.user.image
    cond do
      image -> image
      admin -> ""
      true -> "/images/profile-images/fish.png"
    end
  end

end
