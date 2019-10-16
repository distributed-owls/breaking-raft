defmodule BreakingRaft.AtomicBroadcast do
  use Raft.StateMachine
  
  defstruct [:last_delivered_sequence_number, :messages]

  def name(node), do: :"atomic_bcast_#{node}"

  def broadcast(message) do
    # TODO: refactor to use FE.Result and blog about it
    case Raft.write(name(Node.self()), {:append, message}) do
      {:ok, id} -> {:ok, id}
      {:error, {:redirect, leader}} -> Raft.write(leader, {:append, message})
    end
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
  def init(_name) do
    %__MODULE__{last_delivered_sequence_number: 0, messages: []}
  end

  def handle_write({:append, message}, state) do
    state = %__MODULE__{state |
                        last_delivered_sequence_number: state.last_delivered_sequence_number+1,
                        messages: [message|state.messages]}
    {{:ok, state.last_delivered_sequence_number}, state}
  end

  def handle_read(:delivered_messages, state) do
    {{:ok, Enum.reverse(state.messages)}, state}
  end
end
