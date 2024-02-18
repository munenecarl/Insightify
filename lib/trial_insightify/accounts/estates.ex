defmodule TrialInsightify.Accounts.Estates do
  use Ecto.Schema
  import Ecto.Changeset

  schema "estates" do
    field :estate_id, :id
    field :estate_name, :string

    timestamps(type: :utc_datetime)
  end

  def changeset(estate, attrs) do
    estate
    |> cast(attrs, [:estate_id, :estate_name])
    |> validate_required([:estate_id, :estate_name])
    |> unique_constraint(:estate_id)
  end

end
