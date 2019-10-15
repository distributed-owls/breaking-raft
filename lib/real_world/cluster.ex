defmodule BreakingRaft.RealWorld.Cluster do
  import Eventually
  alias BreakingRaft.RealWorld

  def start(size) do
    {_, 0} = cmd(["stop_cluster"])
    {_, 0} = cmd(["create_network"])

    Enum.map(1..size, &create_node(&1, size))
    |> configure_cluster()
  end

  def configuration(node_id) do
    n = real_world_node(node_id)
    url = "http://#{RealWorld.Node.host(n)}:#{RealWorld.Node.port(n)}/configuration"
    r = HTTPoison.get!(url, [])
    Jason.decode!(r.body)
  end

  defp configure_cluster([n | _] = nodes) do
    names = Enum.map(nodes, fn n -> node_name(n) end)
    url = "http://#{RealWorld.Node.host(n)}:#{RealWorld.Node.port(n)}/configuration"
    HTTPoison.post!(url, Jason.encode!(names))
    names
  end

  defp create_node(node_id, cluster_size) do
    {_, 0} = cmd(["create_node", "#{node_id}", "#{cluster_size}"])
    node = real_world_node(node_id)
    true = wait_for_node(node)
    node
  end

  defp wait_for_node(n) do
    url = "http://#{RealWorld.Node.host(n)}:#{RealWorld.Node.port(n)}/status"

    eventually(fn ->
      case HTTPoison.get(url, []) do
        {:ok, r} -> r.status_code == 200
        _ -> false
      end
    end)
  end

  defp real_world_node(id) do
    {ip, _} = cmd(["node_ip", "#{id}"])
    ip = String.trim(ip)
    RealWorld.Node.new(id, ip)
  end

  defp node_name(node) do
    :"breaking_raft@breaking-raft-#{RealWorld.Node.id(node)}.local"
  end

  defp cmd(cmd) do
    path = Path.join([File.cwd!(), "priv", "cluster.sh"])
    System.cmd(path, cmd, stderr_to_stdout: true)
  end
end
