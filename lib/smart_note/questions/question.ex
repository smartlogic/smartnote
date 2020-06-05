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
    |> validate_required([:title, :body, :answer, :libraries, :tags])
  end

  def update_changeset(struct, params) do
    struct
    |> cast(params, [:title, :body, :answer, :libraries, :tags])
    |> validate_required([:title, :body, :answer, :libraries, :tags])
  end
end
