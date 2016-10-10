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
    field :player1, :string
    field :player2, :string
    field :status, :string
    field :data, :binary

    timestamps
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:player1, :player2])
    |> validate_required(:player1)
    |> validate_required(:player2)
  end

  def create_new_changeset(model, params \\ %{}) do
    model
    |> cast(params, [:player1, :player2])
    |> changeset(params)
    |> create_game(params)
  end

  def create_game(changeset, params) do
    game_data = K2poker.new(params["player1"], params["player2"])
    encoded_game_data = Poison.encode!(game_data)
    put_change(changeset, :status, to_string(game_data.status))
    put_change(changeset, :data, encoded_game_data)
  end

  def decode_game_data(game_data) do
    game = Poison.decode!(game_data, as: %K2poker.Game{})
    players = Enum.map(game.players, fn (player) -> Poison.encode!(player) |> Poison.decode!(as: %K2poker.Player{}) end)
    %{game | players: players}
  end



end
