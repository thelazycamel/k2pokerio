defmodule K2pokerIo.Tournament do

  alias K2pokerIo.Repo

  use K2pokerIoWeb, :model

  schema "tournaments" do
    field :name, :string
    field :default_tournament, :boolean
    field :finished, :boolean
    field :private, :boolean
    belongs_to :user, K2pokerIo.User
    has_many :user_tournament_details, K2pokerIo.UserTournamentDetail
    has_many :invitations, K2pokerIo.Invitation
    field :rebuys, {:array, :integer}  # can be for example [128,1024]
    field :start_time, Ecto.DateTime
    field :lose_type, :string  #one of "all" or "half"
    field :starting_chips, :integer
    field :max_score, :integer
    field :bots, :boolean
    timestamps()
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:name, :private, :user_id, :rebuys, :starting_chips, :max_score, :bots, :lose_type])
    |> validate_required(:name)
  end

  def default do
    Repo.get_by(K2pokerIo.Tournament, default_tournament: true)
  end

end
