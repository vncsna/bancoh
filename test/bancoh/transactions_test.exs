defmodule Bancoh.TransactionsTest do
  use Bancoh.DataCase

  alias Bancoh.Transactions

  describe "transfers" do
    alias Bancoh.Transactions.Transfer

    @valid_attrs %{balance: 120.5}
    @update_attrs %{balance: 456.7}
    @invalid_attrs %{balance: nil}

    def transfer_fixture(attrs \\ %{}) do
      {:ok, transfer} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Transactions.create_transfer()

      transfer
    end

    @tag :skip
    test "list_transfers/0 returns all transfers" do
      transfer = transfer_fixture()
      assert Transactions.list_transfers() == [transfer]
    end

    @tag :skip
    test "get_transfer!/1 returns the transfer with given id" do
      transfer = transfer_fixture()
      assert Transactions.get_transfer!(transfer.id) == transfer
    end

    @tag :skip
    test "create_transfer/1 with valid data creates a transfer" do
      assert {:ok, %Transfer{} = transfer} = Transactions.create_transfer(@valid_attrs)
      assert transfer.balance == 120.5
    end

    @tag :skip
    test "create_transfer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Transactions.create_transfer(@invalid_attrs)
    end

    @tag :skip
    test "update_transfer/2 with valid data updates the transfer" do
      transfer = transfer_fixture()
      assert {:ok, %Transfer{} = transfer} = Transactions.update_transfer(transfer, @update_attrs)
      assert transfer.balance == 456.7
    end

    @tag :skip
    test "update_transfer/2 with invalid data returns error changeset" do
      transfer = transfer_fixture()
      assert {:error, %Ecto.Changeset{}} = Transactions.update_transfer(transfer, @invalid_attrs)
      assert transfer == Transactions.get_transfer!(transfer.id)
    end

    @tag :skip
    test "delete_transfer/1 deletes the transfer" do
      transfer = transfer_fixture()
      assert {:ok, %Transfer{}} = Transactions.delete_transfer(transfer)
      assert_raise Ecto.NoResultsError, fn -> Transactions.get_transfer!(transfer.id) end
    end

    @tag :skip
    test "change_transfer/1 returns a transfer changeset" do
      transfer = transfer_fixture()
      assert %Ecto.Changeset{} = Transactions.change_transfer(transfer)
    end
  end
end
