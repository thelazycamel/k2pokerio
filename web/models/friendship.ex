defmodule K2pokerIo.Friendship do
  use K2pokerIo.Web, :model

  schema "friendships" do
    field :status, :boolean
    belongs_to :user, K2pokerIo.User
    belongs_to :friend, K2pokerIo.User

    timestamps()
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:user_id, :friend_id, :status])
    |> validate_required(:user_id)
    |> validate_required(:friend_id)
    |> validate_required(:status)
  end

end
