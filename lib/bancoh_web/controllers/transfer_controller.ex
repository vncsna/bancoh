defmodule BancohWeb.TransferController do
  use BancohWeb, :controller

  alias Bancoh.Transactions

  plug BancohWeb.Auth when action in [:index, :create, :refund]

  action_fallback BancohWeb.FallbackController

  def index(conn, %{"date_fr" => date_fr, "date_to" => date_to}) do
    id = conn.assigns[:current_user]
    {:ok, date_fr, _} = DateTime.from_iso8601(date_fr <> "T00:00:00Z")
    {:ok, date_to, _} = DateTime.from_iso8601(date_to <> "T23:59:59Z")
    transfers = Transactions.list_transfers(id, date_fr, date_to)
    render(conn, "index.json", transfers: transfers)
  end

  def create(conn, %{"transfer" => transfer_params}) do
    id = conn.assigns[:current_user]
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

  def refund(conn, %{"id" => transfer_id}) do
    user_id = conn.assigns[:current_user]
    transfer = Transactions.get_transfer!(transfer_id)

    if user_id == transfer.sender_id do
      case Transactions.refund_transfer(transfer) do
        {:ok, %{transfer: transfer}} ->
          render(conn, "show.json", transfer: transfer)

        {:error, _failed_operation, failed_value, _changes_so_far} ->
          {:error, failed_value}
      end
    else
      {:error, :unauthorized}
    end
  end
end
