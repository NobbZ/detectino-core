defmodule DtWeb.Event.PartitionEvConf do
  defstruct name: nil,
    type: nil
end

defmodule DtWeb.Event.SensorEvConf do
  defstruct name: nil,
    address: nil,
    port: nil,
    type: nil
end

defmodule DtWeb.Event do
  use DtWeb.Web, :model

  @derive {Poison.Encoder, only: [:id, :name, :description, :source]}
  schema "events" do
    field :name, :string
    field :description, :string
    field :source, :string
    field :source_config, :string

    timestamps

    many_to_many :outputs, DtWeb.Output, join_through: DtWeb.EventOutput
  end

  @required_fields ~w(name source)
  @optional_fields ~w(description source_config)

  def create_changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def update_changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

end
