defmodule SmartNote.Questions do
  @moduledoc """
  Context for creating and managing common questions
  """

  import Ecto.Query, except: [update: 2]

  alias SmartNote.Questions.Question
  alias SmartNote.Repo

  def new(), do: %Question{} |> Question.create_changeset(%{})

  def edit(question), do: question |> Question.update_changeset(%{})

  @doc """
  Get all questions, paginated
  """
  def all(opts \\ []) do
    if is_nil(opts[:search_term]) do
      Repo.paginate(Question, opts)
    else
      search(opts[:search_term])
      |> Repo.paginate(opts)
    end
  end

  # do a naive lookup on all question fields to see if we
  # have any matches
  defp search("") do
    Question
  end

  defp search(search_term) do
    search_term_matcher = "%#{search_term}%"

    Question
    |> where(
      [q],
      ilike(q.title, ^search_term_matcher) or
        ilike(q.body, ^search_term_matcher) or
        ilike(q.answer, ^search_term_matcher) or
        ilike(q.libraries, ^search_term_matcher) or
        fragment("? = ANY(?)", ^search_term, q.tags)
    )
  end

  @doc """
  Get all questions with a specific tag, paginated
  """
  def with_tag(tag, opts \\ []) do
    Question
    |> where([q], fragment("? = ANY(?)", ^tag, q.tags))
    |> Repo.paginate(opts)
  end

  @doc """
    Get all unique tags
    """
    def all_tags() do
      Question
      |> select([q], q.tags)
      |> Repo.all()
      |> Enum.flat_map(fn tag_list -> tag_list end)
      |> Enum.uniq()
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
