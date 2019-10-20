defmodule K2pokerIo.UserStats do

  use K2pokerIoWeb, :data

  schema "user_stats" do
    belongs_to :user, K2pokerIo.User
    field :games_played,    :integer
    field :games_won,       :integer
    field :games_lost,      :integer
    field :games_folded,    :integer
    field :tournaments_won, :integer
    field :duels_won,       :integer
    field :top_score,       :integer
    timestamps()
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:user_id, :games_won, :games_played, :games_lost, :games_folded, :tournaments_won, :duels_won, :top_score])
    |> validate_required(:user_id)
  end

end
