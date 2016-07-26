defmodule PhoenixSessionRedis do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    IO.puts "hello"

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

defmodule Plug.Session.REDIS do
  @behaviour Plug.Session.Store

  def init(opts) do
    {Keyword.fetch!(opts, :table), Keyword.get(opts, :ttl, :infinite)}
  end

  def get(_conn, sid, {table, _}) do
    case :poolboy.transaction(table, &(:eredis.q(&1, ["GET", sid]))) do
      {:ok, :undefined} -> {nil, %{}}
      {:ok, data}       -> {sid, :erlang.binary_to_term(data)}
    end
  end

  def put(_conn, nil, data, state) do
    put_new(data, state)
  end

  def put(_conn, sid, data, {table, _}) do
    case :poolboy.transaction(table, &(:eredis.q(&1, ["SET", sid, data]))) do
      {:ok, _} -> sid
      _ -> raise "Can not put data to Redis."
    end
  end

  def delete(_conn, sid, {table, _}) do
    :poolboy.transaction(table, &(:eredis.q(&1, ["DEL", sid])))
    # TODO add case
  end

  defp put_new(data, {table, ttl}) do
    sid = :crypto.strong_rand_bytes(96) |> Base.encode64
    case :poolboy.transaction(table, &(_store_data_with_ttl(&1, ttl, sid, data))) do
      {:ok, _} -> {sid, data}
      _ -> raise "Can not put data to Redis."
    end
  end

  defp _store_data_with_ttl(client, :infinite, sid, data) do
    :eredis.q(client, ["SET", sid, data])
  end
  defp _store_data_with_ttl(client, ttl, sid, data) do
    :eredis.q(client, ["SET", sid, data])
    :eredis.q(client, ["EXPIRE", sid, ttl])
  end
end
