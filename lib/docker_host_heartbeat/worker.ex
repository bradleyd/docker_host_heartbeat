defmodule DockerHostHeartbeat.Worker do
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    :gen_server.cast self, {:register}
    {:ok, []}
  end

  def loop({:error, error}) do
    IO.inspect error
  end
  
  def loop({:ok, body}) do
    IO.inspect body
    case HTTPoison.post(docker_api_proxy_host <> "/hosts", Poison.encode!(%{name: with_port(interface), hosts: 1}), %{"content-type" => "application/json"}) do
      {:ok, resp} ->
        result = {:ok, Poison.decode(resp.body)}
        :timer.sleep(heartbeat_interval) 
        loop(result)
      {:error, error} ->
        loop({:error, error})
    end
  end
  
  def handle_info(info, state) do
    IO.puts("Received info message #{inspect(info)}")
    {:noreply, state}
  end

  def handle_cast({:register}, []) do
   {:ok, resp } = HTTPoison.post(docker_api_proxy_host <> "/hosts", Poison.encode!(%{name: with_port(interface)}), %{"content-type" => "application/json"})
   result = {:ok, Poison.decode(resp.body)}
   loop(result)
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
    String.to_integer(System.get_env("HEARTBEAT_INTERVAL") || 600000)
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
