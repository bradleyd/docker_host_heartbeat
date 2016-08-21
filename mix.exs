defmodule DockerHostHeartbeat.Mixfile do
  use Mix.Project

  def project do
    [app: :docker_host_heartbeat,
     version: "0.3.0",
     elixir: "~> 1.0",
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger, :httpoison, :poison],
     mod: {DockerHostHeartbeat, []}]
  end

  def escript do
   [main_module: DockerHostHeartbeat] 
  end
  
  defp deps do
    [
      { :httpoison, "~> 0.8" },
      { :exrm, "~> 1.0"},
      { :poison, "~> 2.0"}
    ]
  end
end
