defmodule BancohWeb.TransferView do
  use BancohWeb, :view
  alias BancohWeb.TransferView

  def render("index.json", %{transfers: transfers}) do
    %{data: render_many(transfers, TransferView, "transfer.json")}
  end

  def render("show.json", %{transfer: transfer}) do
    %{data: render_one(transfer, TransferView, "transfer.json")}
  end

  def render("transfer.json", %{transfer: transfer}) do
    %{
      balance: transfer.balance,
      id: transfer.id,
      inserted_at: transfer.inserted_at,
      is_valid: transfer.is_valid,
      receiver_id: transfer.receiver_id,
      sender_id: transfer.sender_id
    }
  end
end
