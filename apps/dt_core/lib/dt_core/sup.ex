defmodule DtCore.Sup do
  @moduledoc """
  Root Supervisor for DtCore supervision tree.
  """
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, nil, [name: __MODULE__])
  end

  def init(_) do
    children = [
      supervisor(DtCore.Sensor.Sup, [], restart: :permanent)
    ]
    supervise(children, strategy: :one_for_all)
  end

end
