defmodule PhoenixSessionRedis do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    children = [:poolboy.child_spec(name, pool, redis)]
    opts = [strategy: :one_for_one, name: PhoenixSessionRedis.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp name, do:, Application.get_env(:phoenix_session_redis, :name)

  defp pool, do: Application.get_env(:phoenix_session_redis, :pool)

  defp redis, do: Application.get_env(:phoenix_session_redis, :redis)
end
