defmodule BancohWeb.UserControllerTest do
  use BancohWeb.ConnCase, async: true

  import Bancoh.Fixtures

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      user = valid_user()
      conn = post(conn, Routes.user_path(conn, :create), user: user)

      assert %{
               "balance" => user.balance,
               "name" => user.name,
               "id" => nil,
               "ssn" => user.ssn,
               "surname" => user.surname
             } == %{json_response(conn, 201)["data"] | "id" => nil}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: invalid_user())
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "auth user" do
    test "renders token if valid user", %{conn: conn} do
      user = user_fixture()
      login = %{"ssn" => user.ssn, "password" => user.password}
      conn = post(conn, Routes.user_path(conn, :auth), user: login)
      assert Map.has_key?(json_response(conn, 200), "token")
    end

    test "renders error if invalid user", %{conn: conn} do
      user = %{"ssn" => "meat", "password" => "pie is tasty"}
      conn = post(conn, Routes.user_path(conn, :auth), user: user)
      assert "Unauthorized" == json_response(conn, 401)
    end
  end
end
