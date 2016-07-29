defmodule PhoenixSessionRedis.Mixfile do
  use Mix.Project

  def project do
    [app: :phoenix_session_redis,
     version: "0.1.0",
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
    [applications: [:logger],
<<<<<<< HEAD
     included_applications: [:eredis],
     mod: {PhoenixSessionRedis, []}]
=======
      mod: {PhoenixSessionRedis, []}]
>>>>>>> 1b3310f3487c06684c7ad7612b16a1612b1718c5
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
