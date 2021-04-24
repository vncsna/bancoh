defmodule Bancoh.Repo.Migrations.AddValidFieldToTransfers do
  use Ecto.Migration

  def change do
    alter table(:transfers) do
      add :is_valid, :boolean, default: true
    end
  end
end
