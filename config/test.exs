use Mix.Config

config :phoenix_session_redis, :config,
  name: :redis_sessions,
  pool: [
    size: 2,
    max_overflow: 5,
    worker_module: :eredis,
    name: {:local, :redis_sessions}
  ],
  redis: [
    host: 'localhost',
    port: 6379,
  ]