defmodule Web.SessionController do
  use Web, :controller

  def new(conn, _params) do
    conn
    |> put_layout("session.html")
    |> render("new.html")
  end

  def delete(conn, _params) do
    conn
    |> clear_session()
    |> redirect(to: Routes.page_path(conn, :index))
  end

  @doc """
  Redirect to the last seen page after being asked to sign in

  Or the home page
  """
  def after_sign_in_redirect(conn, default_path) do
    case get_session(conn, :last_path) do
      nil ->
        redirect(conn, to: default_path)

      path ->
        conn
        |> put_session(:last_path, nil)
        |> redirect(to: path)
    end
  end
end
