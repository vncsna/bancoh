defmodule BancohWeb.UserController do
  use BancohWeb, :controller

  alias Bancoh.Accounts
  alias Bancoh.Accounts.User

  plug BancohWeb.Auth when action in [:show]

  action_fallback BancohWeb.FallbackController

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_path(conn, :show))
      |> render("show.json", user: user)
    end
  end

  def show(conn, _params) do
    id = conn.assigns[:current_user]
    user = Accounts.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def auth(conn, %{"user" => user_params}) do
    with {:ok, token} <- Accounts.auth_user(user_params) do
      render(conn, "auth.json", token: token)
    end
  end
end
