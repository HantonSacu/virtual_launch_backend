defmodule MpgSamsungLaunch do
  use Boundary, deps: [MpgSamsungLaunchConfig, MpgSamsungLaunchSchemas]

  @spec start_link :: Supervisor.on_start()
  def start_link do
    Supervisor.start_link(
      [
        MpgSamsungLaunch.Repo,
        {Phoenix.PubSub, name: MpgSamsungLaunch.PubSub}
      ],
      strategy: :one_for_one,
      name: __MODULE__
    )
  end

  @spec child_spec(any) :: Supervisor.child_spec()
  def child_spec(_arg) do
    %{
      id: __MODULE__,
      type: :supervisor,
      start: {__MODULE__, :start_link, []}
    }
  end
end
