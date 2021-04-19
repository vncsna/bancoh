defmodule BancohWeb.TransferController do
  use BancohWeb, :controller

  alias Bancoh.Transactions
  alias Bancoh.Transactions.Transfer

  action_fallback BancohWeb.FallbackController

  def index(conn, _params) do
    transfers = Transactions.list_transfers()
    render(conn, "index.json", transfers: transfers)
  end

  def create(conn, %{"transfer" => transfer_params}) do
    transfer_params = Map.new(transfer_params, fn {k, v} -> {String.to_atom(k), v} end)
    with {:ok, %{transfer: transfer}} <- Transactions.create_transfer(transfer_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.transfer_path(conn, :show, transfer))
      |> render("show.json", transfer: transfer)
    end
  end

  def show(conn, %{"id" => id}) do
    transfer = Transactions.get_transfer!(id)
    render(conn, "show.json", transfer: transfer)
  end

  # Refund
  def update(conn, %{"id" => id}) do
    transfer = Transactions.get_transfer!(id)

    with {:ok, %{transfer: transfer}} <- Transactions.update_transfer(transfer) do
      render(conn, "show.json", transfer: transfer)
    end
  end

  def delete(conn, %{"id" => id}) do
    transfer = Transactions.get_transfer!(id)

    with {:ok, %Transfer{}} <- Transactions.delete_transfer(transfer) do
      send_resp(conn, :no_content, "")
    end
  end
end
