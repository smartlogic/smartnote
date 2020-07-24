defmodule SmartNote.Repo.Migrations.CreateNotes do
  use Ecto.Migration

  def change do
    create table(:notes, primary_key: false) do
      add(:id, :uuid, primary: true)
      add(:user_id, references(:users), null: false)

      add(:title, :string, null: false)
      add(:body, :text, null: false)
      add(:tags, {:array, :string}, default: fragment("'{}'"), null: false)

      timestamps()
    end
  end
end
