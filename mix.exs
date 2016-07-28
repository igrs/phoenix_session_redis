defmodule PhoenixSessionRedis.Mixfile do
  use Mix.Project

  def project do
    [app: :phoenix_session_redis,
     version: "0.1.0",
     elixir: "~> 1.3",
     description: "This library provid redis pool and Plug.Session.REDIS"
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     package: [
        maintainers: ["igrs"],
        licenses: ["MIT"],
        links: %{"GitHub" => "https://github.com/igrs/phoenix_session_redis"}
      ],
    ]
  end

  def application do
    [applications: [:logger],
      mod: {PhoenixSessionRedis, []}]
  end

  defp deps do
    [
      {:poolboy, "~> 1.5"},
      {:eredis, "~> 1.0"},
      {:plug, "~> 1.1"}
    ]
  end
end
