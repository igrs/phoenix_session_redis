defmodule PhoenixSessionRedisTest do
  use ExUnit.Case, async: true
  use Plug.Test

  @default_opts [
    store: :redis,
    key: "_session_key",
    table: :redis_sessions,
  ]
  @secret String.duplicate("jigitidi", 8)
  @signing_opts Plug.Session.init(Keyword.put(@default_opts, :encrypt, false))

  defp put_envs do
    Application.put_env(
      :phoenix_session_redis,
      :config,
      [
        name: :redis_sessions,
        pool: [size: 2, max_overflow: 5, name: {:local, :redis_sessions}],
        redis: [host: 'localhost', port: 6379]
      ]
    )
  end

  defp sign_conn(conn) do
    put_in(conn.secret_key_base, @secret)
    |> Plug.Session.call(@signing_opts)
    |> fetch_session
  end

  setup_all do
    Application.stop(:phoenix_session_redis)
    put_envs
    :ok = Application.start(:phoenix_session_redis)
    IO.puts "phoenix_session_redis started"
  end

  describe "phoenix_session_redis application" do
    setup do
      [client: :poolboy.checkout(:redis_sessions)]
    end

    test "uses poolboy and eredis", context do
      assert context[:client] != nil
      assert {:ok, "OK"} == :eredis.q(context[:client], ["SET", "some_key", "some_value"])
      assert {:ok, "some_value"} == :eredis.q(context[:client], ["GET", "some_key"])
      assert {:ok, "1"} == :eredis.q(context[:client], ["DEL", "some_key"])
      assert :ok == :poolboy.checkin(:redis_sessions, context[:client])
    end
  end

  describe "phoenix_session_redis Plug.Session.REDIS" do
    test "puts and gets session value" do
      conn = conn(:get, "/")
           |> sign_conn()
           |> put_session("foo", "bar")
           |> send_resp(200, "")
      assert conn |> get_session("foo") == "bar"
    end
  end
end
