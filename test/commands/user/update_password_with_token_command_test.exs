defmodule K2pokerIo.UpdatePasswordWithTokenCommandTest do

  use K2pokerIo.DataCase, async: false

  alias K2pokerIo.Commands.User.UpdatePasswordWithTokenCommand
  alias K2pokerIo.Commands.User.RegisterCommand
  alias K2pokerIo.User

  setup do
    expiry_time = Timex.shift(Timex.now, hours: 2)
    changeset = User.changeset(%User{},
      %{username: "tester",
        email: "test@test.com",
        password: "password123",
        data: %{"token" => "abc123", "token_expiry_time" => expiry_time}}
      )
    {:ok, user} = RegisterCommand.execute(changeset)
    %{user: user}
  end

  test "it should return error if the token is incorrect", _context do
    {:error, message} = UpdatePasswordWithTokenCommand.execute("badpassword", "xyz123", "xyz123")
    assert(message == "No user found")
  end

  test "it should return error if the passwords do not match", _context do
    {:error, message} = UpdatePasswordWithTokenCommand.execute("abc123", "xyz1234", "xyz123")
    assert(message == "Passwords do not match")
  end

  test "it should return error if the password is too short", _context do
    {:error, message} = UpdatePasswordWithTokenCommand.execute("abc123", "x", "x")
    assert(message == "Password too short")
  end

  test "it should update the password and destroy the token", _context do
    {:ok, user} = UpdatePasswordWithTokenCommand.execute("abc123", "xyz123", "xyz123")
    refute(user.data["token"])
    refute(user.data["token_expiry_time"])
    assert(Comeonin.Bcrypt.checkpw("xyz123", user.crypted_password) == true)
  end

end
