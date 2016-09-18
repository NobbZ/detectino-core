defmodule DtCore.Sup do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, nil)
  end

  def init(_) do
    children = [
      worker(DtCore.Receiver, []),
      #worker(DtCore.Handler, []),
      #worker(DtCore.Action, []),
    ]
    supervise(children, strategy: :one_for_one)
  end

end
