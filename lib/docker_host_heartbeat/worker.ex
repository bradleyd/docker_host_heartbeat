defmodule DockerHostHeartbeat.Worker do
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    :erlang.send(self(), :register)
    {:ok, []}
  end

  """
  Register with docker api proxy
  Will keep trying for `heartbeat_interval` milliseconds
  """
  def handle_info(:register, state) do
    IO.puts("Received register message with state: #{inspect(state)}")
    result =
    case HTTPoison.post(docker_api_proxy_host <> "/hosts", Poison.encode!(%{name: with_port(interface), heartbeat_interval: heartbeat_interval}), %{"content-type" => "application/json"}) do
      {:ok, resp} ->
        {:ok, Poison.decode(resp.body)}
      {:error, error} ->
        {:error, error}
    end
    :erlang.send_after(heartbeat_interval, self(), :register)
    {:noreply, result}
  end

  def handle_info(info, state) do
    IO.puts("Received info message #{inspect(info)}")
    {:noreply, state}
  end

  def get_token do
    GenServer.call(__MODULE__, {:token})
  end

  defp interface do
    System.get_env("DOCKER_HOST_INTERFACE") 
  end

  defp docker_api_proxy_host do
    System.get_env("DOCKER_API_PROXY_HOST") || Application.get_env(:docker_proxy, :host)
  end

  defp heartbeat_interval do
    String.to_integer(System.get_env("HEARTBEAT_INTERVAL") || "600000")
  end

  def listening_ip do
    {:ok, ip} = :inet.getifaddrs
    ip_address(ip)
  end

  defp ip_address([head|tail]) do
    ip_address(tail, elem(head, 0))    
  end

  defp ip_address([head|tail], interface) do
    ip_address(head, elem(head, 0))
  end

  defp ip_address({'eth1', rest}, 'eth1') do
    :inet.ntoa(rest[:addr])
  end

  defp ip_address({'eth0', rest}, 'eth0') do
    :inet.ntoa(rest[:addr])
  end

  defp ip_address([], interface) do
    IO.puts "not found"
  end

  def with_port(ip) do
    to_string(ip) <> ":14443"
  end
end
