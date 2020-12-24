# credo:disable-for-this-file Credo.Check.Readability.Specs
# credo:disable-for-this-file VBT.Credo.Check.Consistency.FileLocation

defmodule MpgSamsungLaunchWeb.Main do
  use MpgSamsungLaunchWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end

defmodule MpgSamsungLaunchWeb.Main.View do
  use MpgSamsungLaunchWeb, :view
end
