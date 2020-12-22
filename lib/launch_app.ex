# credo:disable-for-this-file Credo.Check.Readability.Specs

defmodule LaunchApp do
  use Boundary, deps: [Launch, LaunchConfig, LaunchWeb]
  use Application

  def start(_type, _args) do
    LaunchConfig.validate!()

    Supervisor.start_link(
      [
        Launch,
        LaunchWeb
      ],
      strategy: :one_for_one,
      name: __MODULE__
    )
  end

  def config_change(changed, _new, removed) do
    LaunchWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
