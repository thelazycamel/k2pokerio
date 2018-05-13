defmodule K2pokerIo.UpdatePasswordCommandTest do

  use K2pokerIo.ModelCase

  alias K2pokerIo.Commands.User.UpdatePasswordCommand
  alias K2pokerIo.Commands.User.RegisterCommand
  alias K2pokerIo.User
  alias K2pokerIo.Repo
  import Ecto.Query

  setup do
    changeset = User.changeset(%User{}, %{username: "tester", email: "test@test.com", password: "password123"})
    {:ok, user} = RegisterCommand.execute(changeset)
    %{user: user}
  end

  test "it should return error if current password is incorrect", context do
    passwords = %{
      "current-password" => "wrong",
      "new-password" => "abc123",
      "confirm-password" => "abc123"
    }
    {:error, message} = UpdatePasswordCommand.execute(context.user, passwords)
    assert(message == "error_invalid_password")
  end

  test "it should make sure the confirmation password matches", context do
    passwords = %{
      "current-password" => "password123",
      "new-password" => "abc123",
      "confirm-password" => "wrong"
    }
    {:error, message} = UpdatePasswordCommand.execute(context.user, passwords)
    assert(message == "error_password_mismatch")
  end

  test "it should validate the new password", context do
    passwords = %{
      "current-password" => "password123",
      "new-password" => "abc",
      "confirm-password" => "abc"
    }
    {:error, message} = UpdatePasswordCommand.execute(context.user, passwords)
    assert(message == "error_password_length")
  end

  test "it should set the new password if all conditions are good", context do
    passwords = %{
      "current-password" => "password123",
      "new-password" => "abc123",
      "confirm-password" => "abc123"
    }
    assert({:ok} = UpdatePasswordCommand.execute(context.user, passwords))
    user = Repo.one(from u in User, where: u.email == "test@test.com")
    assert(Comeonin.Bcrypt.checkpw("abc123", user.crypted_password) == true)
  end

end
