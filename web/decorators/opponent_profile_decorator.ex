defmodule K2pokerIo.Decorators.OpponentProfileDecorator do

  def decorate(detail) do
    %{opponent: opponent_type} = detail
    case opponent_type do
      "anon" -> present_anon_user(detail)
      "bot" ->  present_bot
      "user" -> present_user(detail)
      _ -> %{}
    end
  end

  defp present_anon_user(detail) do
    %{id: nil, username: detail.username, blurb: "Meh, just an anonymous fish", image: "fish.png"}
  end

  defp present_bot do
    %{id: nil, username: "RandomBot", blurb: "Blackmail is such an ugly word. I prefer extortion. The ‘x’ makes it sound cool.", image: "bender.png"}
  end

  defp present_user(detail) do
    %{id: detail.id, username: detail.username, blurb: detail.blurb, image: detail.image}
  end

end
