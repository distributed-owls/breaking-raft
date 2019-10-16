defmodule BreakingRaft.AtomicBroadcast do
  use Raft.StateMachine

  def name(node), do: :"atomic_bcast_#{node}"

  def configure(nodes) do
    Raft.set_configuration(
      name(Node.self()),
      Enum.map(nodes, fn node -> {name(node), String.to_atom(node)} end)
    )
  end
  
  def leader do
    {_, leader} = Node.self() |> name() |> Raft.leader()
    leader
  end

  def init(_name) do
    []
  end
end
