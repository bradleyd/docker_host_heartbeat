defmodule DockerHostHeartbeat.Worker do
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    docker_proxy = System.get_env("DOCKER_PROXY_HOST") || Application.get_env(:docker_proxy, :host)
    {:ok, resp } = HTTPoison.post("127.0.0.1:4000/hosts", Poison.encode!(%{name: with_port(listening_ip)}), %{"content-type" => "application/json"})
    {:ok, Poison.decode(resp.body)}
  end

  def handle_info(info, state) do
    IO.puts("Received info message #{inspect(info)}")
    {:noreply, state}
  end

  def get_token do
    GenServer.call(__MODULE__, {:token})
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
