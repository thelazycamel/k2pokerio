defmodule K2pokerIo.Invitation do

  use K2pokerIoWeb, :data

  schema "invitations" do
    belongs_to :user, K2pokerIo.User
    belongs_to :tournament, K2pokerIo.Tournament
    field :accepted, :boolean

    timestamps()
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:user_id, :tournament_id, :accepted])
    |> validate_required(:user_id)
    |> validate_required(:tournament_id)
  end

end
