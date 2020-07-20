defmodule Web.QuestionController do
  use Web, :controller

  alias SmartNote.Questions

  def show(conn, %{"id" => id}) do
    case Questions.get(id) do
      {:ok, question} ->
        case Map.has_key?(conn.assigns, :current_user) do
          true ->
            conn
            |> assign(:question, question)
            |> assign(:open_graph_title, question.title)
            |> assign(:open_graph_description, "SmartNote is a FAQ site for SmartLogic")
            |> assign(:open_graph_url, Routes.question_url(conn, :show, question.id))
            |> render("show.html")

          false ->
            conn
            |> assign(:question, question)
            |> assign(:open_graph_title, question.title)
            |> assign(:open_graph_description, "SmartNote is a FAQ site for SmartLogic")
            |> assign(:open_graph_url, Routes.question_path(conn, :show, question.id))
            |> put_session(:last_path, Routes.question_path(conn, :show, question.id))
            |> render("simple.html")
        end

      {:error, :invalid_id} ->
        conn
        |> put_status(404)
        |> put_view(Web.ErrorView)
        |> render(:"404")

      {:error, :not_found} ->
        conn
        |> put_status(404)
        |> put_view(Web.ErrorView)
        |> render(:"404")
    end
  end

  def new(conn, _params) do
    conn
    |> assign(:changeset, Questions.new())
    |> render("new.html")
  end

  def create(conn, %{"question" => params}) do
    case Questions.create(params) do
      {:ok, question} ->
        conn
        |> put_flash(:info, "Question created!")
        |> redirect(to: Routes.question_path(conn, :show, question.id))

      {:error, changeset} ->
        conn
        |> assign(:changeset, changeset)
        |> put_flash(:error, "Could not save the question")
        |> put_status(422)
        |> render("new.html")
    end
  end

  def edit(conn, %{"id" => id}) do
    with {:ok, question} <- Questions.get(id) do
      conn
      |> assign(:question, question)
      |> assign(:changeset, Questions.edit(question))
      |> render("edit.html")
    end
  end

  def update(conn, %{"id" => id, "question" => params}) do
    with {:ok, question} <- Questions.get(id) do
      case Questions.update(question, params) do
        {:ok, question} ->
          conn
          |> put_flash(:info, "Question updated!")
          |> redirect(to: Routes.question_path(conn, :show, question.id))

        {:error, changeset} ->
          conn
          |> assign(:question, question)
          |> assign(:changeset, changeset)
          |> put_flash(:error, "Could not save the question")
          |> put_status(422)
          |> render("edit.html")
      end
    end
  end
end
