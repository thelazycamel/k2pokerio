defmodule K2pokerIo.Decorators.CommentDecorator do

  alias K2pokerIo.User

  def decorate(comment, player_id) do
    %{
      id: comment.id,
      username: comment.user.username,
      image: image(comment),
      comment: comment.comment,
      admin: comment.admin,
      owner: owner(comment, player_id)
     }
  end

  def owner(comment, player_id) do
    comment.user && (User.player_id(comment.user) == player_id)
  end

  def image(comment) do
    admin = comment.admin
    image = comment.user && comment.user.image
    cond do
      image -> "/images/profile-images/#{image}"
      admin -> ""
      true -> "/images/profile-images/fish.png"
    end
  end

end
