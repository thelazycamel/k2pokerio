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
    "user-#{user.id}"
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
