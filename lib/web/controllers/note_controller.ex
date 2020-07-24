defmodule Web.NoteController do
  use Web, :controller

  alias SmartNote.Notes

  plug(Web.Plugs.FetchPage when action in [:index])

  action_fallback(Web.FallbackController)

  def index(conn, _params) do
    %{current_user: user, page: page, per: per} = conn.assigns
    %{page: notes, pagination: pagination} = Notes.for(user, page: page, per: per)

    conn
    |> assign(:notes, notes)
    |> assign(:pagination, pagination)
    |> render("index.html")
  end

  def show(conn, %{"id" => id}) do
    %{current_user: user} = conn.assigns

    with {:ok, note} <- Notes.get(user, id) do
      conn
      |> assign(:note, note)
      |> render("show.html")
    end
  end

  def new(conn, _params) do
    %{current_user: user} = conn.assigns

    conn
    |> assign(:changeset, Notes.new(user))
    |> render("new.html")
  end

  def create(conn, %{"note" => params}) do
    %{current_user: user} = conn.assigns

    case Notes.create(user, params) do
      {:ok, note} ->
        conn
        |> put_flash(:info, "Note created")
        |> redirect(to: Routes.note_path(conn, :show, note.id))

      {:error, changeset} ->
        conn
        |> assign(:changeset, changeset)
        |> put_status(422)
        |> render("new.html")
    end
  end

  def edit(conn, %{"id" => id}) do
    %{current_user: user} = conn.assigns

    with {:ok, note} <- Notes.get(user, id) do
      conn
      |> assign(:note, note)
      |> assign(:changeset, Notes.edit(note))
      |> render("edit.html")
    end
  end

  def update(conn, %{"id" => id, "note" => params}) do
    %{current_user: user} = conn.assigns

    with {:ok, note} <- Notes.get(user, id) do
      case Notes.update(note, params) do
        {:ok, note} ->
          conn
          |> put_flash(:info, "Note updated")
          |> redirect(to: Routes.note_path(conn, :show, note.id))

        {:error, changeset} ->
          conn
          |> assign(:note, note)
          |> assign(:changeset, changeset)
          |> put_status(422)
          |> render("update.html")
      end
    end
  end
end
