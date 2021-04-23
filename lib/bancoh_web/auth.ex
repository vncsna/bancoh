defmodule BancohWeb.Auth do
  import Plug.Conn

  def init(opts), do: opts

  def call(%Plug.Conn{body_params: %{"token" => token}} = conn, _opts) do
    case Phoenix.Token.verify(BancohWeb.Endpoint, "userauth", token, max_age: 1800) do
      {:ok, %{user_id: user_id, user_auth: user_auth}} ->
        conn
        |> assign(:user_id, user_id)
        |> assign(:user_auth, user_auth)

      {:error, _} ->
        conn
        |> halt()
        |> BancohWeb.FallbackController.call({:error, :unauthorized})
    end
  end
end
