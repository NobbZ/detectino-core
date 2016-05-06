defmodule DtWeb.UserControllerTest do
  use DtWeb.ConnCase

  @valid_attrs %{email: "some content", encrypted_password: "some content", name: "some content", password: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "anon: get user", %{conn: conn} do 
    conn = get conn, user_path(conn, :index)
    response(conn, 401)
  end

  test "auth: get user", %{conn: conn} do
    conn = login(conn)
    conn = get conn, user_path(conn, :index)
    json = json_response(conn, 200)

    first = Enum.at(json, 0)
    assert first["username"] == "admin@local"
  end

  def login(conn) do
    conn = post conn, api_login_path(conn, :create), user: %{username: "admin@local", password: "password"}
    json = json_response(conn, 200)

    Phoenix.ConnTest.conn()
    |> put_req_header("accept", "application/json")
    |> put_req_header("authorization", json["token"])
  end

end
