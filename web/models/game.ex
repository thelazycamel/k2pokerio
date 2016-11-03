defmodule K2pokerIo.Game do
  use K2pokerIo.Web, :model

  # NOTE: I think its best to store the data a a binary string which is 
  # decoded by Poison, it is not necessary to query the string, only the
  # player ids which I think are better kept in their own column for easy
  # access, also the status could probably be a boolean, to denote
  # current (inplay) => true, again for easier searching for players current
  # game (after connection lost) - this value would need to check the current game.data status
  # and update accordingly with :finished mapping to 0 and anything else? mapping to 1

  schema "games" do
    field :data, :binary
    field :player1_id
    field :player2_id
    field :value, :integer
    field :open, :boolean
    field :waiting_for_players, :boolean
    belongs_to :tournament, K2pokerIo.Tournament

    timestamps
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:player1_id, :player2_id, :tournament_id, :value, :waiting_for_players, :open])
    |> validate_required(:player1_id)
    |> validate_required(:player2_id)
    |> validate_required(:tournament_id)
    |> validate_required(:value)
    |> validate_required(:waiting_for_players)
  end

  def join_changeset(model, params \\ %{}) do
    model
    |> changeset(params)
    |> create_poker_data(model)
  end

  def create_new_changeset(model, params \\ %{}) do
    model
    |> cast(params, [:player1_id, :tournament_id, :value, :waiting_for_players, :open])
    |> validate_required(:player1_id)
    |> validate_required(:tournament_id)
    |> validate_required(:value)
    |> validate_required(:waiting_for_players)
  end

  def create_poker_data(changeset, model) do
    game_data = K2poker.new(model.player1_id, changeset.changes.player2_id)
    encoded_game_data = Poison.encode!(game_data)
    put_change(changeset, :status, to_string(game_data.status))
    put_change(changeset, :data, encoded_game_data)
  end

  def decode_game_data(game_data) do
    game = Poison.decode!(game_data, as: %K2poker.Game{})
    players = Enum.map(game.players, fn (player) -> Poison.encode!(player) |> Poison.decode!(as: %K2poker.Player{}) end)
    %{game | players: players}
  end

  def player_data(game_data, player_id) do
    if game_data == nil do
      %{status: "Waiting for an opponent"}
    else
     game = decode_game_data(game_data)
     K2poker.player_data(game, player_id)
    end
  end

end
