defmodule Bancoh.Repo.Migrations.CreateTransfers do
  use Ecto.Migration

  def change do
    create table(:transfers) do
      add :balance, :float
      add :sender_id, references(:users, on_delete: :nothing)
      add :receiver_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:transfers, [:sender_id])
    create index(:transfers, [:receiver_id])
  end
end
