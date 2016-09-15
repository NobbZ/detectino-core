defmodule DtWeb.EctoRenderer do

  def render(%{__struct__: _} = struct) do
    struct
    |> Map.from_struct
    |> Map.drop([:__meta__, :__struct__])
  end


end
