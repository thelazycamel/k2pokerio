defmodule K2pokerIo.Game do
  use K2pokerIo.Web, :model

  schema "games" do
    field :data, :binary
    field :player1_id
    field :player2_id
    field :value, :integer
    field :open, :boolean
    field :p1_paid, :boolean
    field :p2_paid, :boolean
    field :waiting_for_players, :boolean
    belongs_to :tournament, K2pokerIo.Tournament

    timestamps
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:player1_id, :player2_id, :tournament_id, :value, :waiting_for_players, :open, :data, :p1_paid, :p2_paid])
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
    put_change(changeset, :data, encoded_game_data)
  end

  def decode_game_data(game_data) do
    data = Poison.decode!(game_data, as: %K2poker.Game{})
    players = Enum.map(data.players, fn (player) -> %K2poker.Player{id: player["id"], cards: player["cards"], status: player["status"]} end)
    %{data | players: players}
  end

  def player_data(game, player_id) do
    cond do
      game.data == nil ->
        %{status: "Waiting for an opponent"}
      true ->
        decode_game_data(game.data)
        |> K2poker.player_data(player_id)
    end
  end

end
