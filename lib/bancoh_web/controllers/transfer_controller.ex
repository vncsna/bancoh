defmodule BancohWeb.TransferController do
  use BancohWeb, :controller

  alias Bancoh.Transactions

  plug BancohWeb.Auth when action in [:index, :create, :refund]

  action_fallback BancohWeb.FallbackController

  def index(conn, %{"date_fr" => date_fr, "date_to" => date_to}) do
    id = conn.assigns[:user_id]
    {:ok, date_fr, _} = DateTime.from_iso8601(date_fr <> "T00:00:00Z")
    {:ok, date_to, _} = DateTime.from_iso8601(date_to <> "T23:59:59Z")
    transfers = Transactions.list_transfers(id, date_fr, date_to)
    render(conn, "index.json", transfers: transfers)
  end

  def create(conn, %{"transfer" => transfer_params}) do
    id = conn.assigns[:user_id]
    transfer_params = Map.merge(transfer_params, %{"sender_id" => id})

    case Transactions.create_transfer(transfer_params) do
      {:ok, %{transfer: transfer}} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", Routes.transfer_path(conn, :index))
        |> render("show.json", transfer: transfer)

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        {:error, failed_value}
    end
  end

  # def show(conn, _params) do
  #   id = conn.assigns[:user_id]
  #   transfer = Transactions.get_transfer!(id)
  #   render(conn, "show.json", transfer: transfer)
  # end

  def refund(conn, _params) do
    id = conn.assigns[:user_id]
    transfer = Transactions.get_transfer!(id)

    case Transactions.refund_transfer(transfer) do
      {:ok, %{transfer: transfer}} ->
        render(conn, "show.json", transfer: transfer)

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        {:error, failed_value}
    end
  end

  # def delete(conn, _params) do
  #   id = conn.assigns[:user_id]
  #   transfer = Transactions.get_transfer!(id)
  # 
  #   with {:ok, %Transfer{}} <- Transactions.delete_transfer(transfer) do
  #     send_resp(conn, :no_content, "")
  #   end
  # end
end
