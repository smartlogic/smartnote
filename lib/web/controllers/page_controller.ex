defmodule Web.PageController do
  use Web, :controller

  alias SmartNote.Questions

  plug(Web.Plugs.FetchPage)

  def index(conn, _params) do
    case Map.has_key?(conn.assigns, :current_user) do
      true ->
        %{page: page, per: per} = conn.assigns
        %{page: questions, pagination: pagination} = Questions.all(page: page, per: per)

        conn
        |> assign(:pagination, pagination)
        |> assign(:questions, questions)
        |> render("questions.html")

      false ->
        render(conn, "index.html")
    end
  end

  def search(conn, %{"search-term" => search_term}) do
    search_term = String.trim(search_term)

    case String.length(search_term) > 0 do
      true ->
        %{page: page, per: per} = conn.assigns

        %{page: questions, pagination: pagination} =
          Questions.all(page: page, per: per, search_term: search_term)

        conn
        |> assign(:search_term, search_term)
        |> assign(:pagination, pagination)
        |> assign(:questions, questions)
        |> render("questions.html")

      false ->
        conn
        |> put_flash(:error, "Invalid search string")
        |> redirect(to: Routes.page_path(conn, :index))
    end
  end

  def health(conn, _params) do
    send_resp(conn, 200, "OK\n")
  end
end
