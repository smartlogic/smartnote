defmodule SmartNote.Repo do
  use Ecto.Repo,
    otp_app: :smart_note,
    adapter: Ecto.Adapters.Postgres

  alias SmartNote.Config
  alias Stein.Pagination

  def init(_type, config) do
    vapor_config = Config.database()

    config =
      Keyword.merge(config,
        url: vapor_config.database_url,
        pool_size: vapor_config.pool_size
      )

    {:ok, config}
  end

  def paginate(query, opts) do
    Pagination.paginate(__MODULE__, query, opts)
  end
end
