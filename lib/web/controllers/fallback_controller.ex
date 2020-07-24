defmodule Web.FallbackController do
  use Web, :controller

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(404)
    |> put_view(Web.ErrorView)
    |> render(:"404")
  end
end
