defmodule Bancoh.Transactions do
  @moduledoc """
  The Transactions context.
  """

  import Ecto.Query, warn: false
  alias Ecto.Multi

  alias Bancoh.Repo
  alias Bancoh.Accounts
  alias Bancoh.Accounts.User
  alias Bancoh.Transactions.Transfer

  @doc """
  Returns the list of transfers.

  ## Examples

      iex> list_transfers()
      [%Transfer{}, ...]

  """
  def list_transfers do
    Repo.all(Transfer)
  end

  @doc """
  Gets a single transfer.

  Raises `Ecto.NoResultsError` if the Transfer does not exist.

  ## Examples

      iex> get_transfer!(123)
      %Transfer{}

      iex> get_transfer!(456)
      ** (Ecto.NoResultsError)

  """
  def get_transfer!(id), do: Repo.get!(Transfer, id)

  @doc """
  Creates a transfer.

  ## Examples

      iex> create_transfer(%{field: value})
      {:ok, %Transfer{}}

      iex> create_transfer(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_transfer(attrs \\ %{}) do
    Multi.new()
    |> Multi.insert(:transfer, Transfer.changeset(%Transfer{}, attrs))
    |> Multi.run(:sender, fn repo, %{transfer: transfer} ->
      User
      |> Repo.get(transfer.sender_id)
      |> (&(User.changeset(&1, %{balance: &1.balance - transfer.balance}))).()
      |> repo.update()
    end)
    |> Multi.run(:receiver, fn repo, %{transfer: transfer} ->
      User
      |> Repo.get(transfer.sender_id)
      |> (&(User.changeset(&1, %{balance: &1.balance + transfer.balance}))).()
      |> repo.update()
    end)
    |> Repo.transaction()
  end

  @doc """
  Updates a transfer.

  ## Examples

      iex> update_transfer(transfer, %{field: new_value})
      {:ok, %Transfer{}}

      iex> update_transfer(transfer, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_transfer(%Transfer{} = transfer) do
    if transfer.is_valid do
      sender = Accounts.get_user!(transfer.sender_id)
      receiver = Accounts.get_user!(transfer.receiver_id)
      sender_change = %{balance: sender.balance + transfer.balance}
      receiver_change = %{balance: receiver.balance - transfer.balance}
  
      Multi.new()
      |> Multi.update(:sender, User.changeset(sender, sender_change))
      |> Multi.update(:receiver, User.changeset(receiver, receiver_change))
      |> Multi.update(:transfer, Transfer.changeset(transfer, %{is_valid: false}))
      |> Repo.transaction()
    else
      {:error, "Transfer was already refunded"}
    end
  end

  @doc """
  Deletes a transfer.

  ## Examples

      iex> delete_transfer(transfer)
      {:ok, %Transfer{}}

      iex> delete_transfer(transfer)
      {:error, %Ecto.Changeset{}}

  """
  def delete_transfer(%Transfer{} = transfer) do
    Repo.delete(transfer)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking transfer changes.

  ## Examples

      iex> change_transfer(transfer)
      %Ecto.Changeset{data: %Transfer{}}

  """
  def change_transfer(%Transfer{} = transfer, attrs \\ %{}) do
    Transfer.changeset(transfer, attrs)
  end
end
