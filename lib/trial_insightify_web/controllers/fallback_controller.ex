defmodule TrialInsightifyWeb.FallbackController do
  use TrialInsightifyWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(TrialInsightifyWeb.ErrorView)
    |> render("error.json", changeset: changeset)
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(html: TrialInsightifyWeb.ErrorHTML, json: TrialInsightifyWeb.ErrorJSON)
    |> render(:"404")
  end
end
