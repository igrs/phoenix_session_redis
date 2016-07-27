defmodule PhoenixSessionRedisTest do
  use ExUnit.Case
  doctest PhoenixSessionRedis, async: true

  @client nil

  def put_envs do
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

  setup_all do
    Application.stop(:phoenix_session_redis)
    put_envs
    :ok = Application.start(:phoenix_session_redis)
    IO.puts "phoenix_session_redis started"
  end

  describe "phoenix_session_redis started" do
    setup do
      [client: :poolboy.checkout(:redis_sessions)]
    end

    test "checkout and checkin connection", context do
      assert context[:client] != nil
      assert :ok == :poolboy.checkin(:redis_sessions, context[:client])
    end

    test "put key value to redis", context do
      assert {:ok, "OK"} == :eredis.q(context[:client], ["SET", "some_key", "some_value"])
      :poolboy.checkin(:redis_sessions, context[:client])
    end

    test "get key value from redis", context do
      assert {:ok, "some_value"} == :eredis.q(context[:client], ["GET", "some_key"])
      :poolboy.checkin(:redis_sessions, context[:client])
    end

    test "delete key value from redis", context do
      assert {:ok, "1"} == :eredis.q(context[:client], ["DEL", "some_key"])
      :poolboy.checkin(:redis_sessions, context[:client])
    end
  end
end
