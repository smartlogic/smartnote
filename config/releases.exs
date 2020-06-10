import Config

config :smart_note, SmartNote.Repo, ssl: true

config :smart_note, Web.Endpoint,
  cache_static_manifest: "priv/static/cache_manifest.json",
  server: true

config :smart_note, :github, callback_module: GitHub.Implementation

config :smart_note, SmartNote.Mailer,
  adapter: Bamboo.MailgunAdapter,
  api_key: {:system, "MAILGUN_API_KEY"},
  domain: {:system, "MAILGUN_DOMAIN"},
  hackney_opts: [
    recv_timeout: :timer.minutes(1)
  ]

config :logger, level: :info

config :phoenix, :logger, false

config :porcelain, driver: Porcelain.Driver.Basic

config :stein_phoenix, :views, error_helpers: Web.ErrorHelpers

config :ueberauth, Ueberauth,
  providers: [
    github: {Ueberauth.Strategy.Github, [allow_private_emails: true]}
  ]
