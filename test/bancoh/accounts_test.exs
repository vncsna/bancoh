defmodule Bancoh.AccountsTest do
  use Bancoh.DataCase

  alias Bancoh.Accounts

  describe "users" do
    alias Bancoh.Accounts.User

    @valid_attrs %{balance: 120.5, name: "some name", ssn: "some ssn", surname: "some surname"}
    @update_attrs %{balance: 456.7, name: "some updated name", ssn: "some updated ssn", surname: "some updated surname"}
    @invalid_attrs %{balance: nil, name: nil, ssn: nil, surname: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.balance == 120.5
      assert user.name == "some name"
      assert user.ssn == "some ssn"
      assert user.surname == "some surname"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)
      assert user.balance == 456.7
      assert user.name == "some updated name"
      assert user.ssn == "some updated ssn"
      assert user.surname == "some updated surname"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
