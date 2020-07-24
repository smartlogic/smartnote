defmodule SmartNote.Users.User do
  @moduledoc """
  User schema
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias SmartNote.Notes.Note

  @type t :: %__MODULE__{}

  schema "users" do
    field(:token, Ecto.UUID)

    field(:username, :string)
    field(:github_uid, :string)

    has_many(:notes, Note)

    timestamps()
  end

  def create_changeset(struct, params) do
    struct
    |> cast(params, [:username, :github_uid])
    |> put_change(:token, UUID.uuid4())
    |> validate_required([:username, :github_uid])
    |> unique_constraint(:github_uid)
  end
end
