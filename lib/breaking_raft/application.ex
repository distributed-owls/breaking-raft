defmodule BreakingRaft.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {BreakingRaft.RealWorld.AtomicBroadcast, [name: :"atomic_bcast_#{Node.self()}"]}
    ]

    opts = [strategy: :one_for_one, name: BreakingRaft.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
