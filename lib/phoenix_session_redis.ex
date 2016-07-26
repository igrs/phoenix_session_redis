defmodule PhoenixSessionRedis do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    #children = [:poolboy.child_spec(name, pool, redis)]
    children = [
      :poolboy.child_spec(
        :redis_sessions,
        [worker_module: :eredis, size: 5, max_overflow: 10], # name: [local: :redis_sessions],
        [database: 0, port: 6379, max_queue: :infinity, reconnect: :no_reconnect, host: 'localhost']
      )
    ]
    opts = [strategy: :one_for_one, name: PhoenixSessionRedis.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def name, do: config[:name]

  def pool, do: config[:pool]

  def redis, do: config[:redis]

  def config, do: Application.get_env(:phoenix_session_redis, :config)
end
