defmodule K2pokerIo.Decorators.BotProfileDecorator do

  def decorate do
    %{
      id: nil,
      username: "RandomBot",
      opponent: :bot,
      blurb: "Blackmail is such an ugly word. I prefer extortion. The ‘x’ makes it sound cool.",
      image: "bender.png",
      friend: :na
    }
  end

end
