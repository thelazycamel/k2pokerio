defmodule K2pokerIo.Badge do

  use K2pokerIoWeb, :model

  schema "badges" do
    field :name, :string
    field :description, :string
    field :action, :string
    field :image, :string
    field :group, :integer
    field :position, :integer
    field :gold, :boolean
    timestamps()
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:name, :description, :action, :image, :group, :position, :gold])
    |> validate_required(:name)
    |> unique_constraint(:name, on: K2pokerIo.Repo)
    |> validate_required(:description)
    |> validate_required(:image)
    |> unique_constraint(:image, on: K2pokerIo.Repo)
    |> validate_required(:group)
    |> validate_required(:position)
    |> validate_required(:gold)
  end

end
