defmodule K2pokerIo.GetUserFromTokenCommandTest do

  use K2pokerIo.ModelCase

  alias K2pokerIo.Commands.User.GetUserFromTokenCommand
  alias K2pokerIo.Commands.User.RegisterCommand
  alias K2pokerIo.User
  alias K2pokerIo.Repo
  import Ecto.Query

  setup do
    expiry_time = Timex.shift(Timex.now, hours: 2)
    changeset = User.changeset(%User{}, %{username: "tester", email: "test@test.com", password: "password123", data: %{"token" => "abc123", "token_expiry_time" => expiry_time}})
    {:ok, user} = RegisterCommand.execute(changeset)
    %{user: user}
  end

  test "it should return ok if token exists and not expired", context do
    {response, user} = GetUserFromTokenCommand.execute("abc123")
    assert(response == :ok)
    assert(user.id == context.user.id)
  end

  test "it should return error if token error" do
    {response, message} = GetUserFromTokenCommand.execute("badToken")
    assert(response == :error)
    assert(message == "No user found")
  end

  test "it should return error if token has expired", context do
    expiry_time = Timex.shift(Timex.now, hours: -1)
    changeset = User.changeset(context.user, %{data: %{"token" => "expired123", "token_expiry_time" => expiry_time}})
    user = Repo.update!(changeset)

    {response, message} = GetUserFromTokenCommand.execute("expired123")
    assert(response == :error)
    assert(message == "Token expired")
  end

end
