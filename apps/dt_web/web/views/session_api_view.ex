defmodule DtWeb.SessionApiView do
  use DtWeb.Web, :view

  def render("logged_in.json", %{token: token}) do
    %{token: token}
  end

end
