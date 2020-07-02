defmodule SmartNote.Questions do
  @moduledoc """
  Context for creating and managing common questions
  """

  import Ecto.Query, except: [update: 2]

  alias SmartNote.Questions.Question
  alias SmartNote.Repo
  alias Stein.Pagination

  def new(), do: %Question{} |> Question.create_changeset(%{})

  def edit(question), do: question |> Question.update_changeset(%{})

  @doc """
  Get all questions, paginated
  """
  def all(opts \\ []) do
    opts = Enum.into(opts, %{})
    Pagination.paginate(Repo, Question, opts)
  end

  @doc """
  Get all questions with a specific tag, paginated
  """
  def with_tag(tag, opts \\ []) do
    opts = Enum.into(opts, %{})

    query =
      Question
      |> where([q], fragment("? = ANY(?)", ^tag, q.tags))

    Pagination.paginate(Repo, query, opts)
  end

  @doc """
  Get a single question
  """
  def get(id) do
    case Ecto.UUID.cast(id) do
      {:ok, id} ->
        case Repo.get(Question, id) do
          nil ->
            {:error, :not_found}

          question ->
            {:ok, question}
        end

      :error ->
        {:error, :invalid_id}
    end
  end

  @doc """
  Create a new question
  """
  def create(%{"tags" => tags} = params) when is_binary(tags) do
    tags =
      tags
      |> String.split(",")
      |> Enum.map(&String.trim/1)

    create(Map.merge(params, %{"tags" => tags}))
  end

  def create(params) do
    %Question{}
    |> Question.create_changeset(params)
    |> Repo.insert()
  end

  @doc """
  Update a question
  """
  def update(question, %{"tags" => tags} = params) when is_binary(tags) do
    tags =
      tags
      |> String.split(",")
      |> Enum.map(&String.trim/1)

    update(question, Map.merge(params, %{"tags" => tags}))
  end

  def update(question, params) do
    question
    |> Question.update_changeset(params)
    |> Repo.update()
  end
end
