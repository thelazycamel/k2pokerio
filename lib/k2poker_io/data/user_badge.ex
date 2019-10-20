defmodule K2pokerIo.UserBadge do

  use K2pokerIoWeb, :data

  schema "user_badges" do
    belongs_to :user, K2pokerIo.User
    belongs_to :badge, K2pokerIo.Badge
    timestamps()
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:user_id, :badge_id])
    |> validate_required([:user_id,:badge_id])
  end

end
