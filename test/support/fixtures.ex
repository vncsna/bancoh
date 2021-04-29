defmodule Bancoh.Fixtures do
  alias Bancoh.Accounts
  alias Bancoh.Transactions

  @valid_user %{
    balance: 100,
    name: "some name",
    password: "some password",
    ssn: "some ssn",
    surname: "some surname"
  }
  @update_user %{
    balance: 456.7,
    name: "some updated name",
    password: "some updated password",
    ssn: "some updated ssn",
    surname: "some updated surname"
  }
  @invalid_user %{
    balance: nil,
    name: nil,
    password: nil,
    ssn: nil,
    surname: nil
  }

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(@valid_user)
      |> Accounts.create_user()

    user
  end

  def valid_user(attrs \\ %{}), do: Enum.into(attrs, @valid_user)
  def update_user(attrs \\ %{}), do: Enum.into(attrs, @update_user)
  def invalid_user(attrs \\ %{}), do: Enum.into(attrs, @invalid_user)

  def transfer_fixture(attrs \\ %{}) do
    {:ok, %{transfer: transfer}} =
      attrs
      |> Enum.into(valid_transfer())
      |> Transactions.create_transfer()

    transfer
  end

  def valid_transfer(attrs \\ %{}) do
    Enum.into(attrs, %{
      balance: 100,
      sender_id: user_fixture(%{ssn: "00000000000"}).id,
      receiver_id: user_fixture(%{ssn: "11111111111"}).id
    })
  end
end
