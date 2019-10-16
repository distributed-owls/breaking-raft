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

end
