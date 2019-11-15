defmodule K2pokerIo.Chat do

  use K2pokerIoWeb, :data

  schema "chats" do
    belongs_to :user, K2pokerIo.User
    belongs_to :tournament, K2pokerIo.Tournament
    field :comment, :string
    field :admin, :boolean
    timestamps()
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:user_id, :tournament_id, :comment, :admin])
    |> validate_required(:user_id)
    |> validate_required(:tournament_id)
    |> validate_required(:comment)
  end

end
