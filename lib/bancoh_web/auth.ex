defmodule BancohWeb.Auth do
  import Plug.Conn
  alias BancohWeb.FallbackController

  def init(opts), do: opts

  def call(%Plug.Conn{} = conn, _opts) do
    with {:ok, token} <- get_token(conn),
         {:ok, %{current_user: current_user}} <- verify_user(token) do
      conn
      |> assign(:current_user, current_user)
    else
      _error ->
        conn
        |> halt()
        |> FallbackController.call({:error, :unauthorized})
    end
  end

  defp get_token(conn) do
    case get_req_header(conn, "authorization") do
      ["Bearer " <> token] -> {:ok, token}
      _ -> {:error}
    end
  end

  defp verify_user(token) do
    Phoenix.Token.verify(BancohWeb.Endpoint, "userauth", token, max_age: 1800)
  end
end
