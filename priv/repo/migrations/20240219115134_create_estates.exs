defmodule TrialInsightify.Repo.Migrations.CreateEstates do
  use Ecto.Migration

  def change do
    create table("estates") do
      add :estate_id, :id
      add :estate_name, :string

      timestamps(type: :utc_datetime)
    end

    create index(:estates, [:estate_id])
  end
end
