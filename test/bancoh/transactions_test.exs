defmodule Bancoh.TransactionsTest do
  use Bancoh.DataCase

  alias Bancoh.Accounts
  alias Bancoh.Transactions
  import Bancoh.Fixtures

  describe "transfers" do
    alias Bancoh.Transactions.Transfer

    test "list_transfers/3 returns all transfers" do
      transfer = transfer_fixture()
      now = DateTime.utc_now()

      assert Transactions.list_transfers(
               transfer.sender_id,
               DateTime.add(now, -10, :second),
               DateTime.add(now, +10, :second)
             ) == [transfer]
    end

    test "get_transfer!/1 returns the transfer with given id" do
      transfer = transfer_fixture()
      assert Transactions.get_transfer!(transfer.id) == transfer
    end

    test "create_transfer/1 with valid data creates a transfer" do
      attrs = valid_transfer()
      assert {:ok, %{transfer: transfer}} = Transactions.create_transfer(attrs)
      assert transfer.balance == attrs.balance
    end

    test "create_transfer/1 with negative balance returns error changeset" do
      attrs = valid_transfer(%{balance: -100})
      assert {:error, :transfer, %Ecto.Changeset{}, _} = Transactions.create_transfer(attrs)
    end

    test "create_transfer/1 with invalid users returns error changeset" do
      attrs = valid_transfer(%{balance: -100})
      assert {:error, :transfer, %Ecto.Changeset{}, _} = Transactions.create_transfer(attrs)
    end

    test "create_transfer/1 with transfer balance greater than user balance returns error changeset" do
      attrs = valid_transfer(%{balance: 200})
      assert {:error, :sender, %Ecto.Changeset{}, _} = Transactions.create_transfer(attrs)
    end

    test "refund_transfer/2 with valid data refunds the transfer" do
      attrs = transfer_fixture()
      assert {:ok, %{transfer: transfer}} = Transactions.refund_transfer(attrs)
      assert transfer.balance == attrs.balance
    end

    @tag :fixed
    test "refund_transfer/2 more than one time returns error changeset" do
      transfer = transfer_fixture()
      assert {:ok, %{transfer: transfer}} = Transactions.refund_transfer(transfer)
      assert {:error, :transfer, %Ecto.Changeset{}, _} = Transactions.refund_transfer(transfer)
      assert transfer == Transactions.get_transfer!(transfer.id)
    end

    test "delete_transfer/1 deletes the transfer" do
      transfer = transfer_fixture()
      assert {:ok, %Transfer{}} = Transactions.delete_transfer(transfer)
      assert_raise Ecto.NoResultsError, fn -> Transactions.get_transfer!(transfer.id) end
    end

    test "change_transfer/1 returns a transfer changeset" do
      transfer = transfer_fixture()
      assert %Ecto.Changeset{} = Transactions.change_transfer(transfer)
    end
  end
end
