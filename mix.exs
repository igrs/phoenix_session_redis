defmodule PhoenixSessionRedis.Mixfile do
  use Mix.Project

  def project do
    [app: :phoenix_session_redis,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [mod: {PhoenixSessionRedis, []}, applications: [:logger]]
  end

  defp deps do
    [
      {:poolboy, "~> 1.5"},
      {:eredis, "~> 1.0"},
      {:plug, "~> 1.1"}
    ]
  end
end
