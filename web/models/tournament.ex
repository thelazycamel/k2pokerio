defmodule K2pokerIo.Tournament do
  use K2pokerIo.Web, :model

  schema "tournaments" do
    field :name, :string
    field :default, :boolean
    field :finished, :boolean
    field :private, :boolean
    belongs_to :user, K2pokerIo.User
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
