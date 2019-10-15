defmodule BreakingRaft.Application do
  @moduledoc false

  use Application
  alias BreakingRaft.RealWorld.AtomicBroadcast

  def start(_type, _args) do
    children = [
      {AtomicBroadcast, [name: AtomicBroadcast.name(Node.self())]},
      {Plug.Cowboy, [scheme: :http, plug: BreakingRaft.Router, options: [port: 4000]]}
    ]

    opts = [strategy: :one_for_one, name: BreakingRaft.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
