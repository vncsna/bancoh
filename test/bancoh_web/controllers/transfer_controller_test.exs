defmodule BancohWeb.TransferControllerTest do
  use BancohWeb.ConnCase, async: true

  import Bancoh.Fixtures

  setup %{conn: conn} do
    sender = user_fixture(%{ssn: "00000000000"})
    receiver = user_fixture(%{ssn: "11111111111"})
    user = %{"ssn" => sender.ssn, "password" => sender.password}

    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> post(Routes.user_path(conn, :auth), user: user)

    assert %{"token" => token} = json_response(conn, 200)

    conn =
      conn
      |> recycle()
      |> put_req_header("authorization", "Bearer " <> token)

    {:ok, conn: conn, users: %{sender_id: sender.id, receiver_id: receiver.id}}
  end

  describe "index" do
    test "lists all transfers", %{conn: conn} do
      date_fr =
        DateTime.utc_now()
        |> DateTime.add(-86400, :second)
        |> datetime_to_string()

      date_to =
        DateTime.utc_now()
        |> DateTime.add(+86400, :second)
        |> datetime_to_string()

      date = %{"date_fr" => date_fr, "date_to" => date_to}
      conn = get(conn, Routes.transfer_path(conn, :index), date)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create transfer" do
    test "renders transfer when data is valid", %{conn: conn, users: users} do
      attrs = valid_transfer(users)
      conn = post(conn, Routes.transfer_path(conn, :create), transfer: attrs)

      assert response = json_response(conn, 201)["data"]
      assert attrs.balance == response["balance"]
      assert true == response["is_valid"]
      assert attrs.receiver_id == response["receiver_id"]
      assert attrs.sender_id == response["sender_id"]
    end

    test "renders errors when data is invalid", %{conn: conn, users: users} do
      attrs = Map.merge(users, %{balance: -100})
      conn = post(conn, Routes.transfer_path(conn, :create), transfer: attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "refund transfer" do
    test "renders transfer when data is valid", %{conn: conn, users: users} do
      transfer = transfer_fixture(users)
      conn = put(conn, Routes.transfer_path(conn, :refund, transfer.id))

      assert %{
               "balance" => transfer.balance,
               "id" => transfer.id,
               "inserted_at" => NaiveDateTime.to_iso8601(transfer.inserted_at),
               "is_valid" => false,
               "receiver_id" => transfer.receiver_id,
               "sender_id" => transfer.sender_id
             } == json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, users: users} do
      transfer = transfer_fixture(users)
      conn = put(conn, Routes.transfer_path(conn, :refund, transfer.id))
      conn = put(conn, Routes.transfer_path(conn, :refund, transfer.id))
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  defp datetime_to_string(date) do
    date
    |> DateTime.to_string()
    |> String.slice(0..9)
  end
end
