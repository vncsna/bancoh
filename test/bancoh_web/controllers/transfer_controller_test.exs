defmodule BancohWeb.TransferControllerTest do
  use BancohWeb.ConnCase

  alias Bancoh.Accounts
  alias Bancoh.Transactions
  alias Bancoh.Transactions.Transfer

  @create_attrs %{balance: 80, sender_id: 1, receiver_id: 2}
  @refund_attrs %{balance: 120, sender_id: 1, receiver_id: 2}
  @invalid_attrs %{balance: nil, sender_id: nil, receiver_id: nil}

  @user_poor %{balance: 0000, name: "1", ssn: "1", surname: "1", password: "111111"}
  @user_rich %{balance: 1000, name: "2", ssn: "2", surname: "2", password: "222222"}

  @date_fr "2020-04-01"
  @date_to "2020-05-01"

  def fixture(:transfer) do
    {:ok, transfer} = Transactions.create_transfer(@create_attrs)
    transfer
  end

  setup %{conn: conn} do
    IO.puts("ENTROU AQUI")

    {:ok, _} = Accounts.create_user(@user_poor)
    {:ok, _} = Accounts.create_user(@user_rich)

    conn = assign(conn, :current_user, 1)
    conn = put_req_header(conn, "accept", "application/json")

    {:ok, conn: conn}
  end

  describe "index" do
    @tag :skip
    test "lists all transfers", %{conn: conn} do
      conn = get(conn, Routes.transfer_path(conn, :index), date_fr: @date_fr, date_to: @date_to)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create transfer" do
    @tag :skip
    test "renders transfer when data is valid", %{conn: conn} do
      conn = post(conn, Routes.transfer_path(conn, :create), transfer: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.transfer_path(conn, :show, id))

      assert %{
               "id" => _id,
               "balance" => 120.5
             } = json_response(conn, 200)["data"]
    end

    @tag :skip
    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.transfer_path(conn, :create), transfer: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "refund transfer" do
    setup [:create_transfer]

    @tag :skip
    test "renders transfer when data is valid", %{
      conn: conn,
      transfer: %Transfer{id: id} = transfer
    } do
      conn = put(conn, Routes.transfer_path(conn, :refund, transfer), transfer: @refund_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.transfer_path(conn, :show, id))

      assert %{
               "id" => _id,
               "balance" => 456.7
             } = json_response(conn, 200)["data"]
    end

    @tag :skip
    test "renders errors when data is invalid", %{conn: conn, transfer: transfer} do
      conn = put(conn, Routes.transfer_path(conn, :refund, transfer), transfer: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  # describe "delete transfer" do
  #   setup [:create_transfer]

  #
  #   test "deletes chosen transfer", %{conn: conn, transfer: transfer} do
  #     conn = delete(conn, Routes.transfer_path(conn, :delete, transfer))
  #     assert response(conn, 204)

  #     assert_error_sent 404, fn ->
  #       get(conn, Routes.transfer_path(conn, :show, transfer))
  #     end
  #   end
  # end

  defp create_transfer(_) do
    transfer = fixture(:transfer)
    %{transfer: transfer}
  end
end
