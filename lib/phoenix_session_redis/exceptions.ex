defmodule PhoenixSessionRedis.ConfigNotFoundError do
  @moduledoc """
  Raised when PhoenixSessionRedis configuration is not found on config.ex or other config.
  This exception is raised by `PhoenixSessionRedis.config/1`
  """
  defexception message: "PhoenixSessionRedis configuration is not found."
end