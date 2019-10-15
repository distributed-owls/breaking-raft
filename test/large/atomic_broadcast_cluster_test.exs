defmodule BreakingRaft.RealWorld.AtomicBroadcastTest do
  use ExUnit.Case

  alias BreakingRaft.{RealWorld}

  test "the cluster can be started and configured" do
    [_, _, _] = RealWorld.Cluster.start(3)

    [
      "breaking_raft@breaking-raft-1.local",
      "breaking_raft@breaking-raft-2.local",
      "breaking_raft@breaking-raft-3.local"
    ] = RealWorld.Cluster.configuration(1) |> Enum.sort()
  end
end
