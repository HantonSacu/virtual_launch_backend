# credo:disable-for-this-file Credo.Check.Readability.Specs

defmodule MpgSamsungLaunchWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :mpg_samsung_launch
  use Sentry.Phoenix.Endpoint

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  @session_options [
    store: :cookie,
    key: "_mpg_samsung_launch_key",
    signing_salt: "UpLmzPIt"
  ]

  socket "/socket", MpgSamsungLaunchWeb.User.Socket,
    websocket: true,
    longpoll: false

  socket "/live", Phoenix.LiveView.Socket, websocket: [connect_info: [session: @session_options]]

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/",
    from: :mpg_samsung_launch,
    gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
    plug Phoenix.Ecto.CheckRepoStatus, otp_app: :mpg_samsung_launch
  end

  plug Phoenix.LiveDashboard.RequestLogger,
    param_key: "request_logger",
    cookie_key: "request_logger"

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug VBT.Kubernetes.Probe, "/healthz"
  plug Plug.Session, @session_options

  if Mix.env() == :test do
    plug MpgSamsungLaunchTest.Web.TestPlug
  end

  plug MpgSamsungLaunchWeb.Router

  @impl Phoenix.Endpoint
  def init(_type, config) do
    config =
      config
      |> Keyword.put(:secret_key_base, MpgSamsungLaunchConfig.secret_key_base())
      |> Keyword.update(:url, url_config(), &Keyword.merge(&1, url_config()))
      |> Keyword.update(:http, http_config(), &(http_config() ++ (&1 || [])))

    {:ok, config}
  end

  defp url_config, do: [host: MpgSamsungLaunchConfig.host()]
  defp http_config, do: [:inet6, port: MpgSamsungLaunchConfig.port()]
end
