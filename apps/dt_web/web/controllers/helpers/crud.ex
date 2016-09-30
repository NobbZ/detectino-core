defmodule DtWeb.CtrlHelpers.Crud do
  use Phoenix.Controller

  import Plug.Conn
  import Ecto.Query, only: [from: 2]

  #
  # XXX implement filtering by relations id also in delete, show, update...
  #

  def all(conn, params, repo, model) do
    filter = model.__schema__(:fields)
    |> build_filter(params)

    page = Map.get(params, "page", "1")
    |> String.to_integer

    per_page = Map.get(params, "per_page", "10")
    |> String.to_integer

    q = from m in model,
      where: ^filter,
      limit: ^per_page,
      offset: ^((page - 1) * per_page)
    items = repo.all(q)

    q = from m in model,
      select: count(m.id),
      where: ^filter
    total = repo.one(q)

    total_s = total
    |> Integer.to_string

    conn = put_resp_header(conn, "x-total-count", total_s)

    links = links(conn, page, per_page, total)
    conn = put_resp_header(conn, "link", links)
  
    {:ok, conn, items}
  end

  def links(conn, page, per_page, total) do
    next_p = nil

    last_p = Float.ceil(total / per_page)
    |> trunc

    link = %ExLinkHeader{
      first: %ExLinkHeaderEntry{
        scheme: conn.scheme,
        host: conn.host,
        path: conn.request_path,
        params: %{per_page: per_page, page: 1}
      },
      last: %ExLinkHeaderEntry{
        scheme: conn.scheme,
        host: conn.host,
        path: conn.request_path,
        params: %{per_page: per_page, page: last_p}
      }
    }

    if total > (page * per_page) do
      next_p = page + 1
      link = %ExLinkHeader{link | next: %ExLinkHeaderEntry{
          scheme: conn.scheme,
          host: conn.host,
          path: conn.request_path,
          params: %{per_page: per_page, page: next_p}
        }}
    end

    ExLinkHeader.build(link)

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
      {:error, changeset} -> {:error, conn, 400, changeset}
    end
  end

  def show(conn, id, module, repo) do
    case repo.get(module, id) do
      nil -> {:error, conn, 404}
      record -> {:ok, conn, record}
    end
  end
  
  def update(conn, params, repo, model) do
    case Map.get(params, "id") do
      :nil -> {:error, conn, 400}
      id -> 
        case repo.get(model, id) do
          nil -> {:error, conn, 404}
          record ->
            model.update_changeset(record, params)
            |> perform_update(repo, conn)
        end
    end
  end

  def delete(conn, params, repo, model) do
    case Map.get(params, "id") do
      id when is_binary(id) ->
        case repo.get(model, id) do
          nil -> {:error, conn, 404}
          record ->
            repo.delete!(record)
            {:response, conn, 204}
        end
      _ -> {:error, conn, 403}
    end
  end

  def delete(conn, _) do
    {:error, conn, 403}
  end

  defp build_filter(fields, params) do
    params = Enum.map(params, fn(param) ->
      {key, value} = param
      {String.to_atom(key), value}
    end
    )
    Enum.filter_map(fields, fn(field) ->
      Keyword.has_key?(params, field)
    end,
    fn(field) ->
      value = Keyword.get(params, field)
      {field, value}
    end
    )
  end

  defp perform_update(changeset, repo, conn) do
    case repo.update(changeset) do
      {:ok, record} ->
        conn = put_status(conn, 200)
        {:ok, conn, record}
      {:error, changeset} ->
        {:error, conn, 400}
    end
  end

end
