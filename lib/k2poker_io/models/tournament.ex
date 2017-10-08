defmodule K2pokerIo.Tournament do

  use K2pokerIoWeb, :model

  schema "tournaments" do
    field :name, :string
    field :default_tournament, :boolean
    field :finished, :boolean
    field :private, :boolean
    belongs_to :user, K2pokerIo.User
    has_many :user_tournament_details, K2pokerIo.UserTournamentDetail
    has_many :invitations, K2pokerIo.Invitation
    field :rebuys, :binary
    field :start_time, Ecto.DateTime
    field :lose_type, :string
    field :starting_chips, :integer
    field :max_score, :integer
    field :bots, :boolean
    timestamps()
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:name, :private, :player_id, :rebuys, :start_time, :player_ids])
    |> validate_required(:name)
  end

end
