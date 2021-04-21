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
      id: transfer.id,
      sender_id: transfer.sender_id,
      receiver_id: transfer.receiver_id,
      date: transfer.inserted_at,
      balance: transfer.balance,
      is_valid: transfer.is_valid
    }
  end
end
