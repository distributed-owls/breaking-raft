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
end
