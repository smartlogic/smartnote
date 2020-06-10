defmodule SmartNote.Users do
  @moduledoc """
  Users context
  """

  alias SmartNote.Config
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
    {:ok, organizations} = GitHub.organizations(auth.extra.raw_info.user)
    intersection = MapSet.intersection(organizations, Config.github_allowed_organizations())

    case !Enum.empty?(intersection) do
      true ->
        create_user(auth)

      false ->
        {:error, :unauthorized}
    end
  end

  defp create_user(auth) do
    attributes = %{
      github_uid: to_string(auth.uid),
      username: auth.info.nickname
    }

    %User{}
    |> User.create_changeset(attributes)
    |> Repo.insert(
      conflict_target: :github_uid,
      on_conflict: {:replace, [:username]},
      returning: true
    )
  end
end
