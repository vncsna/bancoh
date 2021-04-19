defmodule Bancoh.Transactions.Transfer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transfers" do
    field :balance, :float
    field :sender_id, :id
    field :receiver_id, :id
    field :is_valid, :boolean, default: true

    timestamps()
  end

  @doc false
  def changeset(transfer, attrs) do
    transfer
    |> cast(attrs, [:balance, :sender_id, :receiver_id, :is_valid])
    |> validate_required([:balance, :sender_id, :receiver_id])
    |> validate_number(:balance, greater_than: 0)
  end
end
