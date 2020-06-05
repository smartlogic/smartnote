defmodule SmartNote.Repo.Migrations.AddLibrariesToQuestions do
  use Ecto.Migration

  def change do
    alter table(:questions) do
      add(:libraries, :text)
    end
  end
end
