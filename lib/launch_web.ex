# credo:disable-for-this-file VBT.Credo.Check.Consistency.ModuleLayout
# credo:disable-for-this-file Credo.Check.Readability.Specs
# credo:disable-for-this-file Credo.Check.Readability.AliasAs

defmodule LaunchWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use LaunchWeb, :controller
      use LaunchWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  use Boundary,
    deps: [Launch, LaunchConfig, LaunchSchemas],
    exports: [Endpoint]

  @spec start_link :: Supervisor.on_start()
  def start_link do
    Supervisor.start_link(
      [
        LaunchWeb.Telemetry,
        LaunchWeb.Endpoint
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

  def controller do
    quote do
      use Phoenix.Controller, namespace: LaunchWeb

      import Plug.Conn
      import LaunchWeb.Gettext
      alias LaunchWeb.Router.Helpers, as: Routes
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/launch_web/templates",
        namespace: LaunchWeb

      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [get_flash: 1, get_flash: 2, view_module: 1, view_template: 1]

      # Include shared imports and aliases for views
      unquote(view_helpers())
    end
  end

  def router do
    quote do
      use Phoenix.Router

      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import LaunchWeb.Gettext
    end
  end

  defp view_helpers do
    quote do
      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      # Import basic rendering functionality (render, render_layout, etc)
      import Phoenix.View

      import LaunchWeb.ErrorHelpers
      import LaunchWeb.Gettext
      alias LaunchWeb.Router.Helpers, as: Routes
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
