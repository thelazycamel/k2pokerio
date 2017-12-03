defmodule K2pokerIoWeb.TournamentView do

  use K2pokerIoWeb, :view

  def time_ago(date_time) do
    {resp, formatted_time} = Timex.format(date_time, "{relative}", :relative)
    if resp == :ok, do: formatted_time, else: nil
  end

  def profile_image_url(image) do
    if image, do: "/images/profile-images/#{image}", else: "/images/profile-images/fish.png"
  end

end
