defmodule K2pokerIo.Chat do
  use K2pokerIo.Web, :model
  alias K2pokerIo.Repo

  schema "chats" do
    belongs_to :user, K2pokerIo.User
    belongs_to :tournament, K2pokerIo.Tournament
    field :comment, :string
    field :admin, :boolean
    timestamps()
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:user_id, :tournament_id, :comment, :admin])
    |> validate_required(:user_id)
    |> validate_required(:tournament_id)
    |> validate_required(:comment)
  end

  def get_ten_json(tournament_id) do
    query = from c in K2pokerIo.Chat,
      where: c.tournament_id == ^tournament_id,
      join: u in assoc(c, :user),
      limit: 10,
      order_by: [desc: c.inserted_at],
      select: %{id: c.id, username: u.username, comment: c.comment, admin: c.admin}
    comments = K2pokerIo.Repo.all query
    Enum.reverse(comments)
  end

end
