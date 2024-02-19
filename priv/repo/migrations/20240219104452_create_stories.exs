defmodule TrialInsightify.Repo.Migrations.CreateStories do
  use Ecto.Migration

  def change do
    create table("stories") do
      add :story_id, :string
      add :story_title, :string
      add :story_photo, :binary
      add :story_block, :string
      add :estate_id, :string
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:stories, [:user_id])
  end
end
