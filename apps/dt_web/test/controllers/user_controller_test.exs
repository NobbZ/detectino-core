defmodule DtWeb.UserControllerTest do
  use DtWeb.ConnCase

  alias DtWeb.User
  alias DtWeb.ControllerHelperTest, as: Helper

  @valid_attrs %{username: "test@local", email: "some content",
    role: "some content", name: "some content",
    password: "some content"}

  @missing_username %{email: "some content",
    encrypted_password: "some content",
    name: "some content", password: "some content"}

  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "anon: get all users", %{conn: conn} do
    conn = get conn, user_path(conn, :index)
    response(conn, 401)
  end

  test "auth: get all users", %{conn: conn} do
    conn = login(conn)
    conn = get conn, user_path(conn, :index)
    json = json_response(conn, 200)

    assert Enum.count(json) == 1

    total = Helper.get_total(conn)
    assert total == 1

    first = Enum.at(json, 0)
    assert first["username"] == "admin@local"
  end

  test "auth: get one user", %{conn: conn} do
    conn = login(conn)
    conn = get conn, user_path(conn, :show, struct(User, %{"id": "1"}))
    json = json_response(conn, 200)
    assert json["username"] == "admin@local"
  end

  test "auth: get not existent user", %{conn: conn} do
    conn = login(conn)
    conn = get conn, user_path(conn, :show, struct(User, %{"id": "2"}))
    assert conn.status == 404
  end

  test "auth: save one user", %{conn: conn} do
    conn = login(conn)
    conn = post conn, user_path(conn, :create), @valid_attrs
    json = json_response(conn, 201)
    assert json["username"] == "test@local"
  end

  test "auth: save one invalid user", %{conn: conn} do
    conn = login(conn)
    conn = post conn, user_path(conn, :create), @invalid_attrs
    assert conn.status == 400

    token = get_req_header(conn, "authorization")
    |> Enum.at(0)

    conn = Phoenix.ConnTest.build_conn
    |> put_req_header("accept", "application/json")
    |> put_req_header("authorization", token)

    conn = post conn, user_path(conn, :create), @missing_username
    assert conn.status == 400
  end

  test "auth: update one user", %{conn: conn} do
    u = Repo.one!(User)
    assert u.username == "admin@local"

    conn = login(conn)
    params = Map.put(@valid_attrs, "id", "1")
    conn = put conn, user_path(conn, :update, struct(User, %{"id": "1"})), params
    json = json_response(conn, 200)
    assert json["username"] == "test@local"

    u = Repo.one!(User)
    assert u.username == "test@local"

    cnt = Repo.all(User)
    |> Enum.count
    assert cnt == 1
  end

  defp login(conn) do
    conn = post conn, api_login_path(conn, :create), user: %{username: "admin@local", password: "password"}
    json = json_response(conn, 200)

    Phoenix.ConnTest.build_conn
    |> put_req_header("accept", "application/json")
    |> put_req_header("authorization", json["token"])
  end

end
