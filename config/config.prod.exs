use Mix.Config

config :docker_proxy, :host, System.get_env("DOCKER_API_PROXY_HOST")
