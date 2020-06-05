defmodule SmartNote.Users.User do
  @moduledoc """
  User schema
  """

  use Ecto.Schema

  import Ecto.Changeset

  @type t :: %__MODULE__{}

  schema "users" do
    field(:token, Ecto.UUID)

    field(:github_uid, :string)
    field(:email, :string)
    field(:name, :string)

    timestamps()
  end

  def create_changeset(struct, params) do
    struct
    |> cast(params, [:email, :name, :github_uid])
    |> put_change(:token, UUID.uuid4())
    |> validate_required([:email, :name, :github_uid])
    |> unique_constraint(:email, name: :users_lower_email_index)
  end
end
