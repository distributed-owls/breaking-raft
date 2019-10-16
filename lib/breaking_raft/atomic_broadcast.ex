defmodule BreakingRaft.AtomicBroadcast do
  use Raft.StateMachine

  def name(node), do: :"atomic_bcast_#{node}"

  def broadcast(message) do
    Raft.write(name(Node.self()), {:append, message})
  end

  def delivered_messages() do
    case Raft.read(name(Node.self()), :delivered_messages) do
      {:ok, messages} -> {:ok, messages}
      {:error, {:redirect, leader}} -> Raft.read(leader, :delivered_messages)
    end
  end

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

  # Raft statem callbacks
  def init(_name), do: []

  def handle_write({:append, message}, state) do
    {{:ok, message}, [message|state]}
  end

  def handle_read(:delivered_messages, state) do
    {{:ok, Enum.reverse(state)}, state}
  end
end
