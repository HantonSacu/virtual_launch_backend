defmodule Launch.Repo do
  use VBT.Repo,
    otp_app: :launch,
    adapter: Ecto.Adapters.Postgres

  @impl Ecto.Repo
  def init(_type, config) do
    config =
      Keyword.merge(
        config,
        url: LaunchConfig.database_url(),
        pool_size: LaunchConfig.database_pool_size(),
        ssl: LaunchConfig.database_ssl()
      )

    {:ok, config}
  end
end
