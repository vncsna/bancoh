defmodule Bancoh.AccountsTest do
  use Bancoh.DataCase, async: true

  alias Bancoh.Accounts
  import Bancoh.Fixtures

  describe "users" do
    alias Bancoh.Accounts.User

    @tag :fixed
    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [%{user | password: nil}]
    end

    @tag :fixed
    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert %{user | password: nil} == Accounts.get_user!(user.id)
    end

    test "create_user/1 with valid data creates a user" do
      attrs = valid_user()
      assert {:ok, %User{} = user} = Accounts.create_user(attrs)
      assert user.balance == attrs.balance
      assert user.name == attrs.name
      assert user.ssn == attrs.ssn
      assert user.surname == attrs.surname
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(invalid_user())
    end

    @tag :handcrafted
    test "create_user/1 with negative balance returns error changeset" do
      invalid_attrs = %{valid_user() | balance: -100}
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(invalid_attrs)
    end

    @tag :handcrafted
    test "create_user/1 with small password returns error changeset" do
      invalid_attrs = %{valid_user() | password: String.duplicate("x", 4)}
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(invalid_attrs)
    end

    @tag :handcrafted
    test "create_user/1 with large password returns error changeset" do
      invalid_attrs = %{valid_user() | password: String.duplicate("x", 30)}
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(invalid_attrs)
    end

    @tag :handcrafted
    test "create_user/1 with the same ssn returns error changeset" do
      Accounts.create_user(valid_user())
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(valid_user())
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Accounts.update_user(user, update_user())
      assert user.balance == 456.7
      assert user.name == "some updated name"
      assert user.ssn == "some updated ssn"
      assert user.surname == "some updated surname"
    end

    @tag :fixed
    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, invalid_user())
      assert %{user | password: nil} == Accounts.get_user!(user.id)
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
