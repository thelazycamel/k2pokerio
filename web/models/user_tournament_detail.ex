defmodule K2pokerIo.UserTournamentDetail do
  use K2pokerIo.Web, :model

  #TODO look at expiring these after 24 hours of no updates

  schema "user_tournament_details" do

    field :player_id, :string
    field :username, :string
    belongs_to :tournament, K2pokerIo.Tournament
    belongs_to :game, K2pokerIo.Game #SHOULDNT THIS BE HAS ONE GAME ?
    field :current_score, :integer
    field :rebuys, {:array, :integer}

    timestamps()
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:player_id, :username, :tournament_id, :game_id, :current_score, :rebuys])
    |> validate_required(:player_id)
    |> validate_required(:username)
    |> validate_required(:tournament_id)
    |> validate_required(:current_score)
    |> validate_required(:rebuys)
  end

end
