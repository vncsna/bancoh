defmodule BancohWeb.TransferController do
  use BancohWeb, :controller

  alias Bancoh.Transactions
  alias Bancoh.Transactions.Transfer

  plug BancohWeb.Auth when action in [:create, :show, :update]

  action_fallback BancohWeb.FallbackController

  def index(conn, _params) do
    transfers = Transactions.list_transfers()
    render(conn, "index.json", transfers: transfers)
  end

  def create(conn, %{"transfer" => transfer_params}) do
    transfer_params = Map.merge(transfer_params, %{"sender_id" => conn.assigns[:user_id]})

    case Transactions.create_transfer(transfer_params) do
      {:ok, %{transfer: transfer}} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", Routes.transfer_path(conn, :show, transfer))
        |> render("show.json", transfer: transfer)

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        {:error, failed_value}
    end
  end

  def show(conn, %{"id" => id}) do
    transfer = Transactions.get_transfer!(id)
    render(conn, "show.json", transfer: transfer)
  end

  def update(conn, %{"id" => id}) do
    transfer = Transactions.get_transfer!(id)

    case Transactions.update_transfer(transfer) do
      {:ok, %{transfer: transfer}} ->
        render(conn, "show.json", transfer: transfer)

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        {:error, failed_value}
    end
  end

  def delete(conn, %{"id" => id}) do
    transfer = Transactions.get_transfer!(id)

    with {:ok, %Transfer{}} <- Transactions.delete_transfer(transfer) do
      send_resp(conn, :no_content, "")
    end
  end
end
