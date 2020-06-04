defmodule SmartNote.Repo.Migrations.CreateQuestions do
  use Ecto.Migration

  def change do
    create table(:questions, primary_key: false) do
      add(:id, :uuid, primary: true)
      add(:title, :text, null: false)
      add(:body, :text, null: false)
      add(:answer, :text, null: false)
      add(:tags, {:array, :string}, default: fragment("'{}'"), null: false)

      timestamps()
    end
  end
end
