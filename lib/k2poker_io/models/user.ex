defmodule K2pokerIo.User do

  use K2pokerIoWeb, :model

  schema "users" do
    field :email, :string
    field :username, :string
    field :crypted_password, :string
    field :password, :string, virtual: true
    field :image, :string
    field :blurb, :string
    field :data, :map
    has_one :user_stats, {"user_stats", K2pokerIo.UserStats}
    has_many :user_badges, K2pokerIo.UserBadge
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
    |> cast(params, [:email, :username, :password, :image, :data])
    |> unique_constraint(:email, on: K2pokerIo.Repo)
    |> unique_constraint(:username, on: K2pokerIo.Repo)
    |> validate_format(:email, email_regexp())
    |> validate_length(:password, min: 5)
  end

  def profile_changeset(struct, params) do
    struct
    |> cast(params, [:username, :image, :blurb])
  end

  def email_regexp do
    ~r/@/
  end

  def chat_disabled?(user) do
    if user do
      user.data["chat_disabled"] == true
    else
      false
    end
  end

  def admin?(user) do
    if user do
      user.data["admin"] == true
    else
      false
    end
  end

  def mute_sounds?(user) do
    if user do
      user.data["mute"] == true
    else
      false
    end
  end

end
