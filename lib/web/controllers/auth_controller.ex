defmodule Web.AuthController do
  use Web, :controller

  alias SmartNote.Users
  alias Web.SessionController

  plug Ueberauth

  def callback(conn = %{assigns: %{ueberauth_auth: auth}}, %{"provider" => "github"}) do
    case Users.from_social(auth) do
      {:ok, user} ->
        conn
        |> put_session(:user_token, user.token)
        |> put_flash(:info, "Successfully authenticated.")
        |> SessionController.after_sign_in_redirect(Routes.page_path(conn, :index))

      {:error, :unauthorized} ->
        conn
        |> put_flash(:error, "Sorry, you are not authorized.")
        |> redirect(to: Routes.page_path(conn, :index))
    end
  end

  def callback(conn, _params) do
    conn
    |> put_flash(:error, "There was an issue signing in.")
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
