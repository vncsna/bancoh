defmodule Bancoh.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :balance, :float
    field :name, :string
    field :ssn, :string
    field :surname, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:ssn, :name, :surname, :balance])
    |> validate_required([:ssn, :name, :surname, :balance])
    |> validate_number(:balance, greater_than_or_equal_to: 0)
    |> unique_constraint(:ssn)
  end
end
