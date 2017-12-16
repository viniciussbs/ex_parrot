defmodule ExParrotWeb.PageController do
  use ExParrotWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
