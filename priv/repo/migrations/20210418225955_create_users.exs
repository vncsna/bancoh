defmodule Bancoh.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :ssn, :string
      add :name, :string
      add :surname, :string
      add :balance, :float

      timestamps()
    end

    create unique_index(:users, [:ssn])
  end
end
