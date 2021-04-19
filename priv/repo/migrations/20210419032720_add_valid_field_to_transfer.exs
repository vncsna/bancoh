defmodule Bancoh.Repo.Migrations.AddValidFieldToTransfer do
  use Ecto.Migration

  def change do
    alter table(:transfers) do
      add :is_valid, :boolean, default: true
    end
  end
end
