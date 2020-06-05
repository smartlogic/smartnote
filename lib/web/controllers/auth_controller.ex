defmodule Web.AuthController do
  use Web, :controller

  alias SmartNote.Users

  plug Ueberauth

  def callback(conn = %{assigns: %{ueberauth_auth: auth}}, %{"provider" => "github"}) do
    case Users.from_social(auth) do
      {:ok, user} ->
        conn
        |> put_session(:user_token, user.token)
        |> put_flash(:info, "Successfully authenticated.")
        |> redirect(to: "/")
    end
  end

  def callback(conn, _params) do
    conn
    |> put_flash(:error, "There was an issue signing in.")
    |> redirect(to: Routes.session_path(conn, :new))
  end
end
