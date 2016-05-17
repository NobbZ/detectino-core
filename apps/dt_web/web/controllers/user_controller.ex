defmodule DtWeb.UserController do
  use DtWeb.Web, :controller

  alias DtWeb.User
  alias DtWeb.SessionController
  alias DtWeb.StatusCodes
  alias DtWeb.CtrlHelpers.Crud

  alias Guardian.Plug.EnsureAuthenticated

  plug EnsureAuthenticated, [handler: SessionController]

  def index(conn, params) do
    {conn, users} = Crud.all(conn, params, Repo, User)
    render(conn, users: users)
  end

  def create(conn, params) do
    changeset = User.create_changeset(%User{}, params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_resp_header("location", user_path(conn, :show, user))
        |> put_status(201)
        |> render(user: user)
      {:error, changeset} ->
        send_resp(conn, 400, StatusCodes.status_code(400))
    end
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get(User, id)
    case user do
      nil -> send_resp(conn, 404, StatusCodes.status_code(404))
      _ -> render(conn, user: user)
    end
  end

  def update(conn, params) do
    id = case Map.get(params, "id") do
      :nil -> send_resp(conn, 400, StatusCodes.status_code(400))
      v -> v
    end

    changeset = case Repo.get(User, id) do
      nil -> send_resp(conn, 404, StatusCodes.status_code(404))
      user ->
        User.update_changeset(user, params)
        |> perform_update(user, conn)
      _ -> send_resp(conn, 500, StatusCodes.status_code(500))
    end
  end

  def delete(conn, %{"id" => "1"}) do
    send_resp(conn, 403, StatusCodes.status_code(403))
  end

  def delete(conn, %{"id" => id}) when is_binary(id) do
    user = case Repo.get(User, id) do
      nil -> send_resp(conn, 404, StatusCodes.status_code(404))
      user ->
        Repo.delete!(user)
        conn
        |> send_resp(204, StatusCodes.status_code(204))
      _ -> send_resp(conn, 500, StatusCodes.status_code(500))
    end
  end

  def delete(conn, _) do
    send_resp(conn, 403, StatusCodes.status_code(403))
  end

  defp perform_update(changeset, user, conn) do
    case Repo.update(changeset) do
      {:ok, user} ->
        conn
        |> put_status(200)
        |> render(user: user)
      {:error, changeset} ->
        send_resp(conn, 400, StatusCodes.status_code(400))
    end
  end

end
