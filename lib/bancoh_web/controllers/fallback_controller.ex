defmodule BancohWeb.FallbackController do
  @moduledoc """
  Translates controller action errors into valid `Plug.Conn` responses.
  """
  use BancohWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(BancohWeb.ChangesetView)
    |> render("error.json", changeset: changeset)
  end
  
  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(BancohWeb.ErrorView)
    |> render(:"404")
  end

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:unauthorized)
    |> put_view(BancohWeb.ErrorView)
    |> render(:"401")
  end
end
