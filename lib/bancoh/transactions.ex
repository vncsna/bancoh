defmodule Bancoh.Transactions do
  @moduledoc """
  The Transactions context.
  """

  import Ecto.Query, warn: false

  alias Ecto.Multi
  alias Bancoh.Repo
  alias Bancoh.Accounts.User
  alias Bancoh.Transactions.Transfer

  @doc """
  Returns the list of transfers between dates.

  ## Examples

      iex> list_transfers(1, ~N[2020-04-20 00:00:00], ~N[2020-04-20 00:00:00])
      [%Transfer{}, ...]

  """
  def list_transfers(id, date_fr, date_to) do
    Repo.all(
      from t in Transfer,
        where: t.sender_id == ^id,
        where: t.inserted_at >= ^date_fr,
        where: t.inserted_at <= ^date_to,
        select: t
    )
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
      {:ok, %{transfer: %Transfer{}, receiver: %User{}, sender: %User{}}}

      iex> create_transfer(%{field: bad_value})
      {:error, failed_operation, failed_value, changes_so_far}

  """
  def create_transfer(attrs \\ %{}) do
    Multi.new()
    |> Multi.insert(:transfer, Transfer.changeset(%Transfer{}, attrs))
    |> Multi.run(:receiver, increase_balance())
    |> Multi.run(:sender, decrease_balance())
    |> Repo.transaction()
  end

  defp increase_balance(is_refund \\ false) do
    fn repo, %{transfer: transfer} ->
      User
      |> repo.get(if is_refund, do: transfer.sender_id, else: transfer.receiver_id)
      |> (fn user -> User.changeset(user, %{balance: user.balance + transfer.balance}) end).()
      |> repo.update()
    end
  end

  defp decrease_balance(is_refund \\ false) do
    fn repo, %{transfer: transfer} ->
      User
      |> repo.get(if is_refund, do: transfer.receiver_id, else: transfer.sender_id)
      |> (fn user -> User.changeset(user, %{balance: user.balance - transfer.balance}) end).()
      |> repo.update()
    end
  end

  @doc """
  Updates a transfer.

  ## Examples

      iex> refund_transfer(transfer, %{field: new_value})
      {:ok, %{transfer: %Transfer{}, receiver: %User{}, sender: %User{}}}

      iex> refund_transfer(transfer, %{field: bad_value})
      {:error, failed_operation, failed_value, changes_so_far}

  """
  def refund_transfer(%Transfer{} = transfer) do
    Multi.new()
    |> Multi.update(:transfer, Transfer.refund_changeset(transfer, %{is_valid: false}))
    |> Multi.run(:receiver, increase_balance(true))
    |> Multi.run(:sender, decrease_balance(true))
    |> Repo.transaction()
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
