defmodule TrialInsightify.Repo do
  use Ecto.Repo,
    otp_app: :trial_insightify,
    adapter: Ecto.Adapters.Postgres
end
