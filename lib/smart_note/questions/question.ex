defmodule SmartNote.Questions.Question do
  @moduledoc """
  Question schema
  """

  use Ecto.Schema

  import Ecto.Changeset

  @type t :: %__MODULE__{}

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "questions" do
    field(:title, :string)
    field(:body, :string)
    field(:answer, :string)
    field(:libraries, :string)
    field(:tags, {:array, :string})

    timestamps()
  end

  def create_changeset(struct, params) do
    struct
    |> cast(params, [:title, :body, :answer, :libraries, :tags])
    |> validate_required([:title, :body, :answer, :tags])
    |> validate_libraries_format
  end

  def update_changeset(struct, params) do
    struct
    |> cast(params, [:title, :body, :answer, :libraries, :tags])
    |> validate_required([:title, :body, :answer, :tags])
    |> validate_libraries_format
  end

  defp validate_libraries_format(struct) do
    struct
    |> validate_format(
      :libraries,
      ~r/(?:(?:hex|npm)\s+[A-Za-z0-9_-]+\s+[~=><]+\s+[0-9\.]+\n?){1,}/u
    )
  end
end
