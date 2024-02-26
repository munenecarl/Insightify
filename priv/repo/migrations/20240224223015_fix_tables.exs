defmodule TrialInsightify.Repo.Migrations.FixTables do
  alias Ecto.Migration.Table
  use Ecto.Migration

  def up do
    # Drop the foreign key constraints
    execute "ALTER TABLE stories DROP CONSTRAINT IF EXISTS stories_user_id_fkey"

    # Drop the manually added id fields
    alter table(:estates) do
      remove :estate_id
    end

    alter table(:stories) do
      remove :story_id
    end

    # Add the new foreign key constraints
    execute "ALTER TABLE stories ADD CONSTRAINT stories_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE"
  end

  def down do
    # Add the manually added id fields back
    alter table(:estates) do
      add :estate_id, :integer
    end

    alter table(:stories) do
      add :story_id, :string
    end

    # Drop the new foreign key constraints
    execute "ALTER TABLE stories DROP CONSTRAINT IF EXISTS stories_user_id_fkey"

    # Add the old foreign key constraints back
    execute "ALTER TABLE stories ADD CONSTRAINT stories_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE"
  end
end
