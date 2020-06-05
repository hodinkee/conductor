defmodule Conductor.Redirect do
  use Conductor.Schema
  import Ecto.Changeset

  schema "redirects" do
    field :active, :boolean, default: true
    field :code, :string
    field :destination, :string
    field :name, :string
    field :views, :integer, default: 0

    timestamps()
  end

  @doc false
  def changeset(redirect, attrs \\ %{}) do
    redirect
    |> cast(attrs, [:active, :code, :destination, :name, :views])
    |> validate_required([:active, :code, :name, :destination])
    |> unique_constraint(:code)
  end
end
