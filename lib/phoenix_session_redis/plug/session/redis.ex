defmodule Plug.Session.REDIS do
  @moduledoc """
  This is module adopting a Plug.Session.Redis.
  """

  @behaviour Plug.Session.Store

  def init(opts) do
    {Keyword.fetch!(opts, :table), Keyword.get(opts, :max_age, :infinite)}
  end

  def get(_conn, sid, {table, _}) do
    case :poolboy.transaction(table, &(:eredis.q(&1, ["GET", sid]))) do
      {:ok, :undefined} -> {nil, %{}}
      {:ok, data}       -> {sid, :erlang.binary_to_term(data)}
    end
  end

  def put(_conn, nil, data, state), do: put_new(data, state)
  def put(_conn, sid, data, {table, _}) do
    case :poolboy.transaction(table, &(:eredis.q(&1, ["SET", sid, data]))) do
      {:ok, _} -> sid
      _ -> raise "Can't put data to Redis."
    end
  end

  def delete(_conn, sid, {table, _}) do
    case :poolboy.transaction(table, &(:eredis.q(&1, ["DEL", sid]))) do
      {:ok, _} -> :ok
      _ -> raise "Can't delete data from Redis."
    end
  end

  defp put_new(data, {table, ttl}) do
    sid = :crypto.strong_rand_bytes(96) |> Base.encode64
    case :poolboy.transaction(table, &(store_data_with_ttl(&1, ttl, sid, data))) do
      {:ok, _} -> sid
      _ -> raise "Can't put data to Redis."
    end
  end

  defp store_data_with_ttl(client, :infinite, sid, data) do
    :eredis.q(client, ["SET", sid, data])
  end
  defp store_data_with_ttl(client, ttl, sid, data) do
    case :eredis.q(client, ["SET", sid, data]) do
      {:ok, _} -> :eredis.q(client, ["EXPIRE", sid, ttl])
      _ -> raise "Can't put data to Redis."
    end
  end
end
