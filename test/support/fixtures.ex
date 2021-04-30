defmodule Bancoh.Fixtures do
  alias Bancoh.Accounts
  alias Bancoh.Transactions

  @valid_user %{
    balance: 100.0,
    name: "some name",
    password: "some password",
    ssn: "some ssn",
    surname: "some surname"
  }

  @update_user %{
    balance: 120.0,
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
      |> valid_transfer()
      |> Transactions.create_transfer()

    transfer
  end

  def valid_transfer(attrs \\ %{}) do
    attrs
    |> Enum.into(%{balance: 100})
    |> add_user(:sender_id, "00000000000")
    |> add_user(:receiver_id, "11111111111")
  end

  defp add_user(attrs, key, ssn) do
    if Map.has_key?(attrs, key) do
      attrs
    else
      user = user_fixture(%{ssn: ssn})
      Map.put(attrs, key, user.id)
    end
  end
end
