defmodule Bancoh.AccountsTest do
  use Bancoh.DataCase, async: true

  alias Bancoh.Accounts
  import Bancoh.Fixtures

  describe "users" do
    alias Bancoh.Accounts.User

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert [%{user | password: nil}] == Accounts.list_users()
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert %{user | password: nil} == Accounts.get_user!(user.id)
    end

    test "create_user/1 with valid data creates a user" do
      attrs = valid_user()
      assert {:ok, %User{} = user} = Accounts.create_user(attrs)
      assert attrs.balance == user.balance
      assert attrs.name == user.name
      assert attrs.ssn == user.ssn
      assert attrs.surname == user.surname
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(invalid_user())
    end

    test "create_user/1 with negative balance returns error changeset" do
      attrs = %{valid_user() | balance: -100}
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(attrs)
    end

    test "create_user/1 with small password returns error changeset" do
      attrs = %{valid_user() | password: String.duplicate("x", 4)}
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(attrs)
    end

    test "create_user/1 with large password returns error changeset" do
      attrs = %{valid_user() | password: String.duplicate("x", 30)}
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(attrs)
    end

    test "create_user/1 with the same ssn returns error changeset" do
      Accounts.create_user(valid_user())
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(valid_user())
    end

    test "update_user/2 with valid data updates the user" do
      user = update_user()
      assert {:ok, %User{} = updated_user} = Accounts.update_user(user_fixture(), user)
      assert user.balance == updated_user.balance
      assert user.name == updated_user.name
      assert user.ssn == updated_user.ssn
      assert user.surname == updated_user.surname
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      updated_user = invalid_user()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, updated_user)
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
