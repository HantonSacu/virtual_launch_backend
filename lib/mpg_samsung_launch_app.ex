# credo:disable-for-this-file Credo.Check.Readability.Specs

defmodule MpgSamsungLaunchApp do
  use Boundary, deps: [MpgSamsungLaunch, MpgSamsungLaunchConfig, MpgSamsungLaunchWeb]
  use Application

  def start(_type, _args) do
    MpgSamsungLaunchConfig.validate!()

    Supervisor.start_link(
      [
        MpgSamsungLaunch,
        MpgSamsungLaunchWeb
      ],
      strategy: :one_for_one,
      name: __MODULE__
    )
  end

  def config_change(changed, _new, removed) do
    MpgSamsungLaunchWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
