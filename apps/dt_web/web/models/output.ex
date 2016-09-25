defmodule DtWeb.Output do
  use DtWeb.Web, :model

  schema "outputs" do
    field :name, :string
    field :type, :string
    field :enabled, :boolean, default: false

    timestamps

    many_to_many :events, DtWeb.Event, join_through: DtWeb.EventOutput
  end

  @required_fields ~w(name type enabled)
  @optional_fields ~w()

  def create_changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def update_changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

end