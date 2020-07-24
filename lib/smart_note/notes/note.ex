defmodule SmartNote.Notes.Note do
  @moduledoc """
  Note schema
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias SmartNote.Users.User

  @type t :: %__MODULE__{}

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "notes" do
    field(:title, :string)
    field(:body, :string)
    field(:tags, {:array, :string})

    belongs_to(:user, User)

    timestamps()
  end

  def create_changeset(struct, params) do
    struct
    |> cast(params, [:title, :body, :tags])
    |> validate_required([:title, :body, :tags])
  end

  def update_changeset(struct, params) do
    struct
    |> cast(params, [:title, :body, :tags])
    |> validate_required([:title, :body, :tags])
  end
end
