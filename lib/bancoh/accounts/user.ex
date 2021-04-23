defmodule Bancoh.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :balance, :float, default: 0.0
    field :name, :string
    field :ssn, :string
    field :surname, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:ssn, :name, :surname, :balance])
    |> validate_required([:ssn, :name, :surname, :balance])
    |> validate_number(:balance, greater_than_or_equal_to: 0)
    |> unique_constraint(:ssn)
  end

  @doc """
  Registration changeset from "Programming Phoenix ≥ 1.4"
  """
  def registration_changeset(user, attrs) do
    user
    |> changeset(attrs)
    |> cast(attrs, [:password])
    |> validate_length(:password, min: 6, max: 20)
    |> put_pass_hash()
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Pbkdf2.hash_pwd_salt(pass))

      _ ->
        changeset
    end
  end
end
