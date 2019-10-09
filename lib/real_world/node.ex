defmodule BreakingRaft.RealWorld.Node do
  @enforce_keys [:id, :host, :port]
  defstruct [:id, :host, :port]

  def new(id, host) do
    %__MODULE__{id: id, host: host, port: 4000}
  end

  def id(%__MODULE__{id: id}), do: id

  def host(%__MODULE__{host: host}), do: host

  def port(%__MODULE__{port: port}), do: port
end
