defmodule GitHub do
  @moduledoc """
  Fetch information from GitHub
  """

  @callback_module Application.get_env(:smart_note, :github)[:callback_module]

  def organizations(user) do
    @callback_module.organizations(user)
  end
end

defmodule GitHub.Mock do
  @moduledoc false

  def organizations(_user) do
    {:ok, MapSet.new(["github"])}
  end
end

defmodule GitHub.Implementation do
  @moduledoc false

  @doc """
  Get public organizations for a user based on a URL from the auth
  """
  def organizations(user) do
    get(user["organization_url"])
    |> handle_request(fn json ->
      Enum.into(json, MapSet.new(), fn org ->
        org["login"]
      end)
    end)
  end

  defp get(url) do
    Finch.request(SmartNote.HTTPClient, :get, url, [])
  end

  defp handle_request({:ok, response}, fun) do
    case response do
      %{status: 200, body: body} ->
        {:ok, json} = Jason.decode(body)
        {:ok, fun.(json)}

      _ ->
        {:error, :unknown}
    end
  end
end
