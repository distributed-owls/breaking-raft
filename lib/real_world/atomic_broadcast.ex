defmodule BreakingRaft.RealWorld.AtomicBroadcast do
  use Raft.StateMachine
  alias BreakingRaft.Model

  def name(node), do: :"atomic_bcast_#{node}"

  def configure(nodes) do
    Raft.set_configuration(
      name(Node.self()),
      Enum.map(nodes, fn node -> {name(node), String.to_atom(node)} end)
    )
  end

  def init(_name) do
    Model.History.new()
  end

  def history(peer) do
    leader = Raft.leader(peer)
    Raft.read(leader, :history)
  end
end
