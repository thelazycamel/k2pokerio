defmodule K2pokerIo.User do
  use K2pokerIo.Web, :model

  schema "users" do
    field :email, :string
    field :crypted_password, :string
    field :password, :string, virtual: true
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :password])
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 5)
  end
end
