defmodule MpgSamsungLaunch.Repo do
  use VBT.Repo,
    otp_app: :mpg_samsung_launch,
    adapter: Ecto.Adapters.Postgres

  @impl Ecto.Repo
  def init(_type, config) do
    config =
      Keyword.merge(
        config,
        url: MpgSamsungLaunchConfig.database_url(),
        pool_size: MpgSamsungLaunchConfig.database_pool_size(),
        ssl: MpgSamsungLaunchConfig.database_ssl()
      )

    {:ok, config}
  end
end
