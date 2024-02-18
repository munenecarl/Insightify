defmodule TrialInsightify.Accounts.Stories do
  use Ecto.Schema
  import Ecto.Changeset

  schema "stories" do
    field :story_id, :id
    field :story_title, :string
    field :story_photo, :binary
    field :story_block, :string
    field :estate_id, :string
    belongs_to :user, TrialInsightify.Accounts.User

    timestamps(type: :utc_datetime)
  end

  def changeset(stories, attrs) do
    stories
    |> cast(attrs, [:story_id, :story_title, :story_photo, :story_block, :estate_id])
    |> validate_required([:story_id, :story_title, :story_block, :estate_id])
    |> unique_constraint(:story_id)
  end

end
