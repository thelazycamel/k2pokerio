defmodule K2pokerIoWeb.UserAccount do
  import Bamboo.Email

  def forgotten_password(email, token) do
    link = 'https://www.k2poker.io/password/#{token}'
    new_email(
      to: email,
      from: "support@k2poker.io",
      subject: "K2poker Forgotten Password",
      html_body: "<p>Please click the link to reset your password <a href='#{link}'>#{link}</a></p>",
      text_body: "Please click the link to reset your password #{link}"
    )
  end
end
