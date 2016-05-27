defmodule DtWeb.CtrlHelpers.Crud do
  use Phoenix.Controller

  import Plug.Conn
  import Ecto.Query, only: [from: 2]

  alias DtWeb.StatusCodes

  def all(conn, params, repo, model) do
    page = Map.get(params, "page", "1")
    |> String.to_integer

    per_page = Map.get(params, "per_page", "10")
    |> String.to_integer

    q = from m in model,
      limit: ^per_page,
      offset: ^((page-1) * per_page)
    items = repo.all(q)

    q = from m in model,
      select: count(m.id)
    total = repo.one(q)

    total_s = total
    |> Integer.to_string

    conn = put_resp_header(conn, "x-total-count", total_s)

    links = links(conn, page, per_page, total)
    conn = put_resp_header(conn, "link", links)
  
    {conn, items}
  end

  def links(conn, page, per_page, total) do
    schema = conn.scheme
    host = conn.host
    path = conn.request_path
    next_p = page + 1
    last_p = Float.ceil(total / per_page)
    |> trunc

    %ExLinkHeader{
      first: %ExLinkHeaderEntry{
        scheme: conn.scheme,
        host: conn.host,
        path: conn.request_path,
        q_params: %{per_page: per_page, page: 1}
      },
      next: %ExLinkHeaderEntry{
        scheme: conn.scheme,
        host: conn.host,
        path: conn.request_path,
        q_params: %{per_page: per_page, page: next_p}
      },
      last: %ExLinkHeaderEntry{
        scheme: conn.scheme,
        host: conn.host,
        path: conn.request_path,
        q_params: %{per_page: per_page, page: last_p}
      },
    }
    |> ExLinkHeader.build

  end

  def create(conn, params, module, repo, path_fn) do
    changeset = module.create_changeset(struct(module), params)

    case repo.insert(changeset) do
      {:ok, record} ->
        path = apply(DtWeb.Router.Helpers, path_fn, [conn, :show, record])
        conn = conn
                |> put_resp_header("location", path)
                |> put_status(201)
        {:ok, conn, record}
      {:error, _changeset} ->
        {:error, conn, 400}
    end
  end

end
