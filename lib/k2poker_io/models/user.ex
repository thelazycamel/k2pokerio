defmodule K2pokerIo.User do

  use K2pokerIoWeb, :model

  schema "users" do
    field :email, :string
    field :username, :string
    field :crypted_password, :string
    field :password, :string, virtual: true
    field :image, :string
    field :blurb, :string
    timestamps()
  end

  def player_id(user) do
    "user|#{user.id}"
  end

  def get_id(player_id) do
    cond do
      player_id == "" -> {:error, :no_player_id}
      player_id == nil -> {:error, :no_player_id}
      String.match?(player_id, ~r/^BOT/) ->
        {:bot, nil}
      String.match?(player_id, ~r/^user/) ->
        [type, user_id] = String.split(player_id, "|")
        {user_id, _} = Integer.parse(user_id)
        {String.to_atom(String.downcase(type)), user_id}
      String.match?(player_id, ~r/^anon/) ->
        [type, _] = String.split(player_id, "|")
        {String.to_atom(String.downcase(type)), nil}
      true -> {:error, :no_player_id}
    end
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :username, :password])
    |> unique_constraint(:email)
    |> unique_constraint(:username)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 5)
  end

  def profile_changeset(struct, params) do
    struct
    |> cast(params, [:username, :image, :blurb])
  end

end
