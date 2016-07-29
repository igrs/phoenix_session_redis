defmodule PhoenixSessionRedis.Mixfile do
  use Mix.Project

  def project do
    [app: :phoenix_session_redis,
     version: "0.1.1",
     elixir: "~> 1.3",
     description: "This library provid redis pool and Plug.Session.REDIS",
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
    [applications: [:logger, :eredis, :poolboy, :plug],
      mod: {PhoenixSessionRedis, []}]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.13", only: :dev},
      {:poolboy, "~> 1.5"},
      {:eredis, "~> 1.0"},
      {:plug, "~> 1.1"}
    ]
  end
end
