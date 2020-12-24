# credo:disable-for-this-file VBT.Credo.Check.Consistency.ModuleLayout
# credo:disable-for-this-file Credo.Check.Readability.Specs
# credo:disable-for-this-file Credo.Check.Readability.AliasAs

defmodule MpgSamsungLaunchWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use MpgSamsungLaunchWeb, :controller
      use MpgSamsungLaunchWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  use Boundary,
    deps: [MpgSamsungLaunch, MpgSamsungLaunchConfig, MpgSamsungLaunchSchemas],
    exports: [Endpoint]

  @spec start_link :: Supervisor.on_start()
  def start_link do
    Supervisor.start_link(
      [
        MpgSamsungLaunchWeb.Telemetry,
        MpgSamsungLaunchWeb.Endpoint
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

  def controller(_opts) do
    quote do
      use Phoenix.Controller, namespace: MpgSamsungLaunchWeb

      import Plug.Conn
      import Phoenix.LiveView.Controller
      import MpgSamsungLaunchWeb.Gettext
      alias MpgSamsungLaunchWeb.Router.Helpers, as: Routes

      plug :put_layout, {MpgSamsungLaunchWeb.Layout.View, :app}
      plug :put_view, __MODULE__.View
    end
  end

  def view(opts) do
    quote do
      default_opts = [root: Path.relative_to_cwd(__DIR__), path: "templates"]

      use Phoenix.View, Keyword.merge(default_opts, unquote(opts))

      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [get_flash: 1, get_flash: 2, view_module: 1, view_template: 1]

      import Phoenix.LiveView.Helpers

      # Include shared imports and aliases for views
      unquote(view_helpers())
    end
  end

  def live_view(_opts) do
    quote do
      use Phoenix.LiveView
      alias MpgSamsungLaunchWeb.Router.Helpers, as: Routes

      unquote(view_helpers())
    end
  end

  def router(_opts) do
    quote do
      use Phoenix.Router

      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  def channel(_opts) do
    quote do
      use Phoenix.Channel
      import MpgSamsungLaunchWeb.Gettext
    end
  end

  defp view_helpers do
    quote do
      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      # Import basic rendering functionality (render, render_layout, etc)
      import Phoenix.View

      import MpgSamsungLaunchWeb.Error.Helpers
      import MpgSamsungLaunchWeb.Gettext
      alias MpgSamsungLaunchWeb.Router.Helpers, as: Routes
    end
  end

  defmacro __using__(which), do: apply_fun(which)

  defp apply_fun(fun) when is_atom(fun), do: apply_fun({fun, []})
  defp apply_fun({fun, opts}), do: apply(__MODULE__, fun, [opts])
end
