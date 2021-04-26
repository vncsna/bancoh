defmodule BancohWeb.UserController do
  use BancohWeb, :controller

  alias Bancoh.Accounts
  alias Bancoh.Accounts.User

  if Mix.env() != :test do
    plug BancohWeb.Auth when action in [:show]
  end

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

  # def index(conn, _params) do
  #   users = Accounts.list_users()
  #   render(conn, "index.json", users: users)
  # end

  # def update(conn, %{"user" => user_params}) do
  #   id = conn.assigns[:current_user]
  #   user = Accounts.get_user!(id)
  # 
  #   with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
  #     render(conn, "show.json", user: user)
  #   end
  # end

  # def delete(conn, _params) do
  #   id = conn.assigns[:current_user]
  #   user = Accounts.get_user!(id)
  # 
  #   with {:ok, %User{}} <- Accounts.delete_user(user) do
  #     send_resp(conn, :no_content, "")
  #   end
  # end
end
