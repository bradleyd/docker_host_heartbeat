defmodule DockerHostHeartbeat.Mixfile do
  use Mix.Project

  def project do
    [app: :docker_host_heartbeat,
     version: "0.0.1",
     elixir: "~> 1.0",
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger, :httpoison],
     mod: {DockerHostHeartbeat, []}]
  end

  def escript do
   [main_module: DockerHostHeartbeat] 
  end
  
  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
      { :httpoison, "~> 0.6" },
      { :poison, "~> 1.3"}
    ]
  end
end