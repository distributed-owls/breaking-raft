defmodule BreakingRaft.RealWorld.AtomicBroadcastTest do
  use ExUnit.Case

  alias BreakingRaft.{Model, RealWorld}

  test "the cluster can be started and configured" do
    [n1, n2, n3] = RealWorld.Cluster.start(3)

    :foo = RealWorld.Cluster.configuration(1)
  end
end
