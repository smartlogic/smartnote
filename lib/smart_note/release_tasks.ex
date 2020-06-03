# Loosely from https://github.com/bitwalker/distillery/blob/master/docs/Running%20Migrations.md
defmodule SmartNote.ReleaseTasks do
  @moduledoc false

  @start_apps [
    :crypto,
    :ssl,
    :postgrex,
    :ecto,
    :ecto_sql
  ]

  @repos [
    SmartNote.Repo
  ]

  def startup() do
    IO.puts("Loading smart_note...")

    # Load the code for smart_note, but don't start it
    Application.load(:smart_note)

    IO.puts("Starting dependencies..")
    # Start apps necessary for executing migrations
    Enum.each(@start_apps, &Application.ensure_all_started/1)

    # Start the Repo(s) for smart_note
    IO.puts("Starting repos..")
    Enum.each(@repos, & &1.start_link(pool_size: 2))
  end
end

defmodule SmartNote.ReleaseTasks.Migrate do
  @moduledoc """
  Migrate the database
  """

  alias SmartNote.ReleaseTasks
  alias SmartNote.Repo

  @apps [
    :smart_note
  ]

  @doc """
  Migrate the database
  """
  def run() do
    ReleaseTasks.startup()
    Enum.each(@apps, &run_migrations_for/1)
    IO.puts("Success!")
  end

  def priv_dir(app), do: "#{:code.priv_dir(app)}"

  defp run_migrations_for(app) do
    IO.puts("Running migrations for #{app}")
    Ecto.Migrator.run(Repo, migrations_path(app), :up, all: true)
  end

  defp migrations_path(app), do: Path.join([priv_dir(app), "repo", "migrations"])
end
