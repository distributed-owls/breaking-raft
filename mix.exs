defmodule BreakingRaft.MixProject do
  use Mix.Project

  def project do
    [
      app: :breaking_raft,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      preferred_cli_env: [release: :prod]
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {BreakingRaft.Application, []}
    ]
  end

  defp deps do
    [
      {:eventually, github: "distributed-owls/eventually"},
      {:httpoison, "~> 1.6"},
      {:raft, github: "toniqsystems/raft"}
    ]
  end
end
