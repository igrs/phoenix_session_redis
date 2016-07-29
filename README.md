# PhoenixSessionRedis
[![Build Status](https://travis-ci.org/igrs/phoenix_session_redis.svg?branch=master)](https://travis-ci.org/igrs/phoenix_session_redis)
[![hex.pm version](https://img.shields.io/hexpm/v/phoenix_session_redis.svg)](https://hex.pm/packages/phoenix_session_redis)
[![MIT License](http://img.shields.io/badge/license-MIT-blue.svg?style=flat)](LICENSE)

PhoenixSessionRedis provide redis pool and Plug.Session.REDIS.
Depends on eredis, poolboy and plug.

It is assumed that application is created Phoenix Framework
and run multi(or one) web server with one redis server for session.
But not limited Phoenix Framework.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `phoenix_session_redis` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:phoenix_session_redis, "~> 0.1.1"}]
    end
    ```

  2. Ensure `phoenix_session_redis` is started before your application:

    ```elixir
    def application do
      [applications: [:phoenix_session_redis]]
    end
    ```

## Usage

Add below example to your Phoenix Framework project.

  * config/config.exs

    ```elixir
    config :phoenix_session_redis, :config,
      name: :redis_sessions,            # Pool name
      pool: [
        size: 2,                        # Number of worker
        max_overflow: 5,                # Max Additional worker
        name: {:local, :redis_sessions} # First is determination where the pool is run
                                        # Second is unique pool name
      ],
      redis: [                          # Worker arguments
        host: 'localhost',              # Redis host(it is char list !)
        port: 6379,                     # Redis port
      ]
    ```

  * lib/endpoint.ex

    ```elixir
    plug Plug.Session,
      store: :redis,                           # Plug.Session.REDIS module
      key: _session_key                        # Cookie name
      table: :redis_sessions,                  # Pool name
      max_age: 1 * 60 * 60                     # use this value as Redis expiration
    ```

## Licence
See [LICENSE](https://github.com/igrs/phoenix_session_redis/blob/master/LICENSE).

## Contribution
1. Fork it
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create new Pull Request
