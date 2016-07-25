defmodule PhoenixSessionRedis do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    children = [:poolboy.child_spec(name, pool, redis)]
    opts = [strategy: :one_for_one, name: PhoenixSessionRedis.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def name, do: config[:name]

  def pool, do: config[:pool]

  def redis, do: config[:redis]

  def config, do: Application.get_env(:phoenix_session_redis, :config)
end
