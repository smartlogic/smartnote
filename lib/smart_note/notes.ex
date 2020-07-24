defmodule SmartNote.Notes do
  @moduledoc """
  Context for notes

  Private notepad that can be shared similar to gists.
  """

  import Ecto.Query

  alias SmartNote.Notes.Note
  alias SmartNote.Repo

  @doc """
  Changeset for a new note
  """
  def new(user) do
    user
    |> Ecto.build_assoc(:notes)
    |> Note.create_changeset(%{})
  end

  @doc """
  Changeset for editing a note
  """
  def edit(note) do
    Note.update_changeset(note, %{})
  end

  @doc """
  Get notes for a user
  """
  def for(user, opts \\ []) do
    Note
    |> where([n], n.user_id == ^user.id)
    |> Repo.paginate(opts)
  end

  @doc """
  Get a note scoped to a user
  """
  def get(user, id) do
    case Repo.get_by(Note, id: id, user_id: user.id) do
      nil ->
        {:error, :not_found}

      note ->
        {:ok, note}
    end
  end

  @doc """
  Create a note for a user
  """
  def create(user, %{"tags" => tags} = params) when is_binary(tags) do
    tags =
      tags
      |> String.split(",")
      |> Enum.map(&String.trim/1)

    create(user, Map.merge(params, %{"tags" => tags}))
  end

  def create(user, params) do
    user
    |> Ecto.build_assoc(:notes)
    |> Note.create_changeset(params)
    |> Repo.insert()
  end

  @doc """
  Update a note
  """
  def update(note, %{"tags" => tags} = params) when is_binary(tags) do
    tags =
      tags
      |> String.split(",")
      |> Enum.map(&String.trim/1)

    __MODULE__.update(note, Map.merge(params, %{"tags" => tags}))
  end

  def update(note, params) do
    note
    |> Note.update_changeset(params)
    |> Repo.update()
  end
end
