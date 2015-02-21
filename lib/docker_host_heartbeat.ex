defmodule DockerHostHeartbeat do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(DockerHostHeartbeat.Worker, [])
    ]

    opts = [strategy: :one_for_one, name: DockerHostHeartbeat.Supervisor]
    Application.ensure_all_started(:httpoison)
    Supervisor.start_link(children, opts)
  end
end
