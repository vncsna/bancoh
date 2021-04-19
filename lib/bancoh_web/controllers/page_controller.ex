defmodule BancohWeb.PageController do
  use BancohWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
