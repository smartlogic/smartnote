defmodule SmartNote.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  alias SmartNote.Config

  def start(_type, _args) do
    load_config()

    children = [
      {Phoenix.PubSub, name: SmartNote.PubSub},
      SmartNote.Config.Cache,
      {Finch, name: SmartNote.HTTPClient},
      SmartNote.Repo,
      Web.Endpoint
    ]

    opts = [strategy: :one_for_one, name: SmartNote.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp load_config() do
    config = Config.application()

    Application.put_env(:ueberauth, Ueberauth.Strategy.Github.OAuth,
      client_id: config.github_client_id,
      client_secret: config.github_client_secret
    )
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Web.Endpoint.config_change(changed, removed)
    :ok
  end
end
