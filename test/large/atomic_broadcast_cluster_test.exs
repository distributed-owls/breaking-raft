defmodule BreakingRaft.RealWorld.AtomicBroadcastTest do
  use ExUnit.Case

  alias BreakingRaft.RealWorld

  test "the cluster can be started" do
    [n1, n2, n3] = RealWorld.Cluster.start(3)

    assert RealWorld.Cluster.leader(n1) == RealWorld.Cluster.leader(n2)
    assert RealWorld.Cluster.leader(n2) == RealWorld.Cluster.leader(n3)
  end

  test "a broadcast message can be delivered to all peers" do
    # given
    [n1, n2, n3] = RealWorld.Cluster.start(3)

    # when
    RealWorld.Cluster.broadcast(n1, "hello")

    # then
    assert RealWorld.Cluster.delivered_messages(n1) == ["hello"]
    assert RealWorld.Cluster.delivered_messages(n2) == ["hello"]
    assert RealWorld.Cluster.delivered_messages(n3) == ["hello"]
  end

  test "a broadcast message can be accepted by any node" do
    # given
    [n1, n2, n3] = RealWorld.Cluster.start(3)

    # when
    RealWorld.Cluster.broadcast(n1, "a")
    RealWorld.Cluster.broadcast(n2, "b")
    RealWorld.Cluster.broadcast(n3, "c")

    # then
    assert RealWorld.Cluster.delivered_messages(n1) == ["a", "b", "c"]
    assert RealWorld.Cluster.delivered_messages(n2) == ["a", "b", "c"]
    assert RealWorld.Cluster.delivered_messages(n3) == ["a", "b", "c"]
  end

  test "the cluster can accept concurrent broadcasts" do
    # given
    [n1, n2, n3] = RealWorld.Cluster.start(3)
    messages = MapSet.new(["x", "y", "z"])

    # when
    messages_in_broadcast_order =
      RealWorld.Cluster.concurrent_broadcast(n1, messages)

    # then
    assert MapSet.new(messages_in_broadcast_order) == messages
    assert RealWorld.Cluster.delivered_messages(n1) ==
      messages_in_broadcast_order
    assert RealWorld.Cluster.delivered_messages(n2) ==
      messages_in_broadcast_order
    assert RealWorld.Cluster.delivered_messages(n3) ==
      messages_in_broadcast_order
  end

  # parallel broadcast
  # 1. stop node, we can write
  # 2. stop 2 nodes, we cant' write
  # 3. stop node, restart it, we can write
  # 4. stop 2 nodes, restart 1, we can write
  # 5. stop 2 nodes, restart 2, we can write (?)



end
