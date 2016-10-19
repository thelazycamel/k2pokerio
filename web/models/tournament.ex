defmodule K2pokerIo.Tournament do
  use K2pokerIo.Web, :model

  schema "tournaments" do
    field :name, :string
    field :default, :boolean #only true for the main "K2 Summit Ascent"
    field :finished, :boolean
    field :top_player, :string #same as player_id keep reference to player
    field :private, :boolean
    field :player_id, :string #Creators player_id, note can be anon player
    field :rebuys, :integer #number of rebuys allowed
    field :start_time, Ecto.DateTime
    field :player_ids, {:array, :string} #private tourneys, keep an array of player ids allowed to play
    timestamps
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:name, :private, :player_id, :rebuys, :start_time, :player_ids])
    |> validate_required(:name)
  end

end
