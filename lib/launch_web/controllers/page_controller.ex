# credo:disable-for-this-file Credo.Check.Readability.Specs

defmodule LaunchWeb.PageController do
  use LaunchWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
