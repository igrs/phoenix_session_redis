defmodule PhoenixSessionRedis do
  @moduledoc """
  Stores the session in a Redis.

  It is assumed that application is created Phoenix Framework
  and run multi(or one) web server with one redis server for session.
  (But maybe It can use other elixir application)

  ## Examples

    config/config.exs

      config :phoenix_session_redis, :config,
        name: :redis_sessions,            # Pool name
        pool: [
          size: 2,                        # Number of worker
          max_overflow: 5,                # Max Additional worker
          name: {:local, :redis_sessions} # First is determination where the pool is run
                                          # Second is unique pool name
        ],
        redis: [                          # Worker arguments
          host: 'localhost',              # Redis host(it is char list !)
          port: 6379,                     # Redis port
        ]

    lib/endpoint.ex

      plug Plug.Session,
        store: :redis,                           # Plug.Session.REDIS module
        table: :redis_sessions,                  # Pool name
        max_age: 1 * 60 * 60                     # use this value as Redis expiration
  """

  use Application

  @doc false
  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    children = [
      :poolboy.child_spec(:redis_sessions, config(:pool) ++ [worker_module: :eredis], config(:redis))
    ]
    opts = [strategy: :one_for_one, name: PhoenixSessionRedis.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @doc """
    Get phoenix_session_redis config.
    if configuration is not found, raise ConfigNotFoundError
  """
  defp config(key) do
    case Application.get_env(:phoenix_session_redis, :config)[key] do
      nil  -> raise PhoenixSessionRedis.ConfigNotFoundError
      conf -> conf
    end
  end
end
