defmodule SmartNote.Users do
  @moduledoc """
  Users context
  """

  alias SmartNote.Repo
  alias SmartNote.Users.User

  @doc """
  Changeset for updating a user
  """
  def edit(user), do: Ecto.Changeset.change(user, %{})

  @doc """
  Get a user by id
  """
  def get(id) do
    case Repo.get(User, id) do
      nil ->
        {:error, :not_found}

      user ->
        {:ok, user}
    end
  end

  @doc """
  Find an user by the token
  """
  def from_token(token) do
    case Repo.get_by(User, token: token) do
      nil ->
        {:error, :not_found}

      user ->
        {:ok, user}
    end
  end

  @doc """
  Create a new user based on social data
  """
  def from_social(auth = %{provider: :github}) do
    attributes = %{
      github_uid: to_string(auth.uid),
      email: auth.info.email,
      name: auth.info.name
    }

    %User{}
    |> User.create_changeset(attributes)
    |> Repo.insert(
      conflict_target: {:unsafe_fragment, "(lower(email))"},
      on_conflict: {:replace, [:github_uid]},
      returning: true
    )
  end
end
