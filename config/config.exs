# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :sentry,
  dsn: {:system, "SENTRY_DSN"},
  environment_name: {:system, "RELEASE_LEVEL"},
  enable_source_code_context: true,
  root_source_code_path: File.cwd!(),
  included_environments: ~w(prod stage develop preview),
  release: Launch.MixProject.project()[:version]

config :launch, Launch.Repo,
  adapter: Ecto.Adapters.Postgres,
  migration_primary_key: [type: :binary_id],
  migration_timestamps: [type: :utc_datetime_usec],
  otp_app: :launch

config :launch, ecto_repos: [Launch.Repo], generators: [binary_id: true]

# Configures the endpoint
config :launch, LaunchWeb.Endpoint,
  render_errors: [view: LaunchWeb.ErrorView, accepts: ["html", "json"], layout: false],
  pubsub_server: Launch.PubSub,
  live_view: [signing_salt: "i/BeocKU"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
