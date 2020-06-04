defmodule Web.QuestionController do
  use Web, :controller

  alias SmartNote.Questions

  def show(conn, %{"id" => id}) do
    with {:ok, question} <- Questions.get(id) do
      conn
      |> assign(:question, question)
      |> render("show.html")
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
