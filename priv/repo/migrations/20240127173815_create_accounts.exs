defmodule Kerching.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :name, :text

      timestamps()
    end
  end
end
