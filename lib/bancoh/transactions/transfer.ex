defmodule Bancoh.Transactions.Transfer do
  use Ecto.Schema
  import Ecto.Changeset
  alias Bancoh.Accounts.User

  schema "transfers" do
    field :balance, :float
    field :is_valid, :boolean, default: true
    belongs_to :sender, User
    belongs_to :receiver, User

    timestamps()
  end

  @doc false
  def changeset(transfer, attrs) do
    transfer
    |> cast(attrs, [:balance, :sender_id, :receiver_id, :is_valid])
    |> validate_required([:balance, :sender_id, :receiver_id])
    |> validate_number(:balance, greater_than: 0)
    |> foreign_key_constraint(:sender_id)
    |> foreign_key_constraint(:receiver_id)
  end

  @doc false
  def refund_changeset(transfer, attrs) do
    transfer
    |> changeset(attrs)
    |> already_refunded?(transfer)
  end

  @doc false
  defp already_refunded?(changeset, transfer) do
    if transfer.is_valid do
      changeset
    else
      add_error(changeset, :is_valid, "transfer was already refunded")
    end
  end
end
