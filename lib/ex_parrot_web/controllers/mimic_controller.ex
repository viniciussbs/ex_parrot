defmodule ExParrotWeb.MimicController do
  use ExParrotWeb, :controller

  def mimic(conn, _params) do
    result =
      conn
      |> mimic_request()
      |> send_request()

    case result do
      {:ok, response} ->
        conn
        |> mimic_response_headers(response.headers)
        |> send_resp(response.status, response.body)
        |> halt()
      {:error, :not_implemented} ->
        conn
        |> put_resp_header("content-type", "text/plain")
        |> send_resp(:not_implemented, "")
        |> halt()
    end
  end

  # REQUEST

  defp mimic_request(conn) do
    %{}
    |> Map.put(:method, conn.method)
    |> mimic_request_url(conn)
    |> mimic_request_body(conn)
  end

  defp mimic_request_url(req, %Plug.Conn{request_path: path}) do
    url = Application.get_env(:ex_parrot, :source) <> path
    Map.put(req, :url, url)
  end

  defp mimic_request_body(req, %Plug.Conn{} = conn) do
    with {:ok, body, _conn} <- read_body(conn) do
      Map.put(req, :body, body)
    end
  end

  defp send_request(%{url: url, method: method, body: body}) do
    case method do
      "GET"  -> {:ok, Tesla.get(url)}
      "POST" -> {:ok, Tesla.post(url, body)}
      _      -> {:error, :not_implemented}
    end
  end

  # RESPONSE

  defp mimic_response_headers(conn, headers) do
    Enum.reduce headers, conn, fn {key, value}, conn ->
      put_resp_header(conn, key, value)
    end
  end
end
