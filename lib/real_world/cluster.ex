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

  defp configure_cluster(nodes) do
    Enum.map(nodes, fn n ->
      node_name(n)
    end)
    |> IO.inspect(label: :node_names)
  end

  defp create_node(node_id, cluster_size) do
    {_, 0} = cmd(["create_node", "#{node_id}", "#{cluster_size}"])
    true = wait_for_node(node_id)
    node_id
  end

  defp wait_for_node(node_id) do
    n = real_world_node(node_id)
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

  defp node_name(node_id) do
    exec(node_id, ["rpc", "'IO.puts(Node.self())'"])
  end

  defp exec(node_id, cmd) do
    bin =
      "/breaking-raft/_build/prod/rel/" <>
        "breaking_raft/bin/breaking_raft"

    cmd(["exec", "#{node_id}", bin] ++ cmd)
  end

  defp cmd(cmd) do
    path = Path.join([File.cwd!(), "priv", "cluster.sh"])
    System.cmd(path, cmd, stderr_to_stdout: true)
  end
end
