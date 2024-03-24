defmodule TrialInsightify.Accounts.Estates do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  schema "estates" do
    field :estate_name, :string

    timestamps(type: :utc_datetime)
  end

  def changeset(estate, attrs) do
    estate
    |> cast(attrs, [:estate_id, :estate_name])
    |> validate_required([:estate_id, :estate_name])
    |> unique_constraint(:estate_id)
  end

  def search(text) do
    TrialInsightify.Repo.all(from e in __MODULE__, where: ilike(e.estate_name, ^text), select: e.estate_name)
  end

  def list_estates do
    TrialInsightify.Repo.all(from e in __MODULE__, select: e)
  end

  def get_estate_by_name(estate_name) do

  end

end
