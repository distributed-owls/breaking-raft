defmodule BreakingRaft.RealWorld.AtomicBroadcast do
  use Raft.StateMachine
  alias BreakingRaft.Model

  def init(_name) do
    Model.History.new()
  end

  def history(peer) do
    leader = Raft.leader(peer)
    Raft.read(leader, :history)
  end
end
