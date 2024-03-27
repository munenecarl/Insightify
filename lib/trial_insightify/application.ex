defmodule TrialInsightify.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  Dotenv.load!()

  @impl true
  def start(_type, _args) do
    children = [
      TrialInsightifyWeb.Telemetry,
      TrialInsightify.Repo,
      {DNSCluster, query: Application.get_env(:trial_insightify, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: TrialInsightify.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: TrialInsightify.Finch},
      # Start a worker by calling: TrialInsightify.Worker.start_link(arg)
      # {TrialInsightify.Worker, arg},
      # Start to serve requests, typically the last entry
      TrialInsightifyWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TrialInsightify.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TrialInsightifyWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
