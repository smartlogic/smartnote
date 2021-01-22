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

  # Why is this so cursed?
  # `libraries` is a big text field that should look for example like:
  #     hex ecto ~> 3.0
  #     hex foobar == 1.0
  #     npm dataclice > 0.1
  #
  # So, let's just make sure we always have that format for every line
  # here so we don't have to mess around further upstream with bad data.
  defp validate_libraries_format(struct) do
    struct
    |> validate_format(
      :libraries,
      ~r/(?:(?:hex|npm)\s+[A-Za-z0-9_-]+\s+[~=><]+\s+[0-9\.]+\n?){1,}/u
    )
  end
end
