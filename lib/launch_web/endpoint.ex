# credo:disable-for-this-file Credo.Check.Readability.Specs

defmodule LaunchWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :launch
  use Sentry.Phoenix.Endpoint

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  @session_options [
    store: :cookie,
    key: "_launch_key",
    signing_salt: "UpLmzPIt"
  ]

  socket "/socket", LaunchWeb.UserSocket,
    websocket: true,
    longpoll: false

  socket "/live", Phoenix.LiveView.Socket, websocket: [connect_info: [session: @session_options]]

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/",
    from: :launch,
    gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
    plug Phoenix.Ecto.CheckRepoStatus, otp_app: :launch
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
    plug LaunchTest.Web.TestPlug
  end

  plug LaunchWeb.Router

  @impl Phoenix.Endpoint
  def init(_type, config) do
    config =
      config
      |> Keyword.put(:secret_key_base, LaunchConfig.secret_key_base())
      |> Keyword.update(:url, url_config(), &Keyword.merge(&1, url_config()))
      |> Keyword.update(:http, http_config(), &(http_config() ++ (&1 || [])))

    {:ok, config}
  end

  defp url_config, do: [host: LaunchConfig.host()]
  defp http_config, do: [:inet6, port: LaunchConfig.port()]
end
