defmodule ExParrotWeb.MimicControllerTest do
  use ExParrotWeb.ConnCase

  setup do
    Application.put_env(:ex_parrot, :source, "http://httpbin.org")
  end

  test "Not supported HTTP methods", %{conn: conn} do
    conn = delete(conn, "/delete")
    assert text_response(conn, 501) == ""
  end

  test "GET request", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "httpbin(1):"
  end

  test "GET request to another endpoint", %{conn: conn} do
    conn = get(conn, "/ip")
    assert %{"origin" => _my_external_ip} = json_response(conn, 200)
  end

  test "POST request", %{conn: conn} do
    conn =
      conn
      |> put_req_header("content-type", "text/plain")
      |> post("/post", "lorem ipsum")

    assert %{"data" => "lorem ipsum"} = json_response(conn, 200)

    # TODO: Testar se o content-type tá certo no request e na resposta
  end
end
