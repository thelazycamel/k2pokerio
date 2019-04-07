defmodule K2pokerIo.RequestNewPasswordCommandTest do

  use K2pokerIo.ModelCase

  alias K2pokerIo.Commands.User.RequestNewPasswordCommand
  alias K2pokerIo.Commands.User.RegisterCommand
  alias K2pokerIo.User
  alias K2pokerIo.Repo
  import Ecto.Query

  setup do
    changeset = User.changeset(%User{}, %{username: "tester", email: "test@test.com", password: "password123", data: %{test: "some data"}})
    {:ok, user} = RegisterCommand.execute(changeset)
    %{user: user}
  end

  test "it should return error if can't find a user", context do
    {:error, message} = RequestNewPasswordCommand.execute("unidentified@user.com")
    assert(message == "Email does not exist")
  end

  test "it should update the token and expiry time of the user", context do
    {:ok, user} = RequestNewPasswordCommand.execute("test@test.com")
    token = user.data["token"]
    token_expiry_time = NaiveDateTime.to_iso8601(user.data["token_expiry_time"])
    |> Timex.parse!("{ISO:Extended}")

    assert(String.length(token) == 42)
    assert(Timex.before?(token_expiry_time, Timex.shift(Timex.now, hours: 5)))
    assert(user.data["test"] == "some data")
  end

end
