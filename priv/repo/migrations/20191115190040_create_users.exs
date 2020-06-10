defmodule SmartNote.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add(:username, :string, null: false)
      add(:token, :uuid, null: false)
      add(:github_uid, :string, null: false)

      timestamps()
    end

    create index(:users, [:github_uid], unique: true)
  end
end
