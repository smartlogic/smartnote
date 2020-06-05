defmodule SmartNote.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add(:email, :string, null: false)
      add(:name, :string, null: false)
      add(:token, :uuid, null: false)
      add(:github_uid, :string, null: false)

      timestamps()
    end

    create index(:users, ["lower(email)"], unique: true)
  end
end
