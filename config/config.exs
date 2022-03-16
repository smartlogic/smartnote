# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :smart_note,
  namespace: Web,
  ecto_repos: [SmartNote.Repo]

config :smart_note, :github, callback_module: GitHub.Implementation

# Configures the endpoint
config :smart_note, Web.Endpoint,
  render_errors: [view: Web.ErrorView, accepts: ~w(html json)],
  pubsub_server: SmartNote.PubSub

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :ueberauth, Ueberauth,
  providers: [
    github: {Ueberauth.Strategy.Github, [allow_private_emails: true]}
  ]

if File.exists?("config/#{Mix.env()}.exs") do
  import_config "#{Mix.env()}.exs"
end
