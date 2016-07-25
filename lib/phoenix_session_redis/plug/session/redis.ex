defmodule Plug.Session.Redis do
  @behaviour Plug.Session.Store

  def init(opts) do
    {Keyword.fetch!(opts, :table), Keyword.get(opts, :ttl, :infinite)}
  end

  def get(_conn, sid, {table, _}) do
    case :poolboy.transaction(table, &(:eredis.q(&1, ["GET", sid]))) do
      {:ok, data} -> {sid, data}
      _ -> {nil, %{}}
    end
  end

  def put(_conn, nil, data, state) do
    put_new(data, state)
  end

  def put(_conn, sid, data, {table, _}) do
    case :poolboy.transaction(table, &(:eredis.q(&1, ["SET", sid, data]))) do
      {:ok, _data} -> sid
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
      {:ok, data} -> {sid, data}
      _ -> raise "Can not put data to Redis."
    end
  end

  defp _store_data_with_ttl(client, :infinite, sid, data) do
    :eredis.q(client, ["SET", sid, data])
  end
  defp _store_data_with_ttl(client, ttl, sid, data) do
    :eredis.q(client, [["SET", sid, data], ["EXPIRE", sid, ttl]])
  end
end
