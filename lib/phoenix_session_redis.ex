defmodule PhoenixSessionRedis do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    pool_options = [
      {:name, {:local, :redis_sessions}},
      {:worker_module, :eredis},
      {:size, 5},
      {:max_overflow, 10}
    ]
    eredis_args = [
      {:host, 'localhost'},
      {:port, 6379}
    ]
    # Define workers and child supervisors to be supervised
    children = [
      :poolboy.child_spec(
        :redis_sessions,
        pool_options,
        #[database: 0, port: 6379, max_queue: :infinity, reconnect: :no_reconnect, host: 'localhost']
        eredis_args
      )
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PhoenixSessionRediss.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
