defmodule BreakingRaft.RealWorld.Cluster do
  import Eventually
  alias BreakingRaft.RealWorld

  def start(size) do
    {_, 0} = cmd(["stop_cluster"])
    {_, 0} = cmd(["create_network"])

    Enum.map(1..size, &create_node(&1, size))
    |> configure_cluster()
  end

  def leader(n) do
    %{status_code: 200} = r = HTTPoison.get!(node_url(n, "/leader"), [])
    Jason.decode!(r.body)
  end

  def broadcast(n, message) do
    %{status_code: 200} = HTTPoison.post!(node_url(n, "/broadcast"), message)
    # todo return shit
  end

  def delivered_messages(n) do
    %{status_code: 200} = r = HTTPoison.get!(node_url(n, "/delivered_messages"), [])
    Jason.decode!(r.body)
  end

  defp configure_cluster([n | _] = nodes) do
    names = Enum.map(nodes, fn n -> node_name(n) end)
    HTTPoison.post!(node_url(n, "/configuration"), Jason.encode!(names))
    nodes
  end

  defp node_url(n, suffix) do
    "http://#{RealWorld.Node.host(n)}:#{RealWorld.Node.port(n)}" <> suffix
  end

  defp create_node(node_id, cluster_size) do
    {_, 0} = cmd(["create_node", "#{node_id}", "#{cluster_size}"])
    node = real_world_node(node_id)
    true = wait_for_node(node)
    node
  end

  defp wait_for_node(n) do
    status_url = node_url(n, "/status")
    eventually(fn ->
      case HTTPoison.get(status_url, []) do
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
