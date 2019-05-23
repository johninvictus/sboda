defmodule SbodaWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.
  """
  use SbodaWeb, :controller

  def call(conn, {:changeset_error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render(SbodaWeb.ChangesetView, "error.json", changeset: changeset)
  end

  def call(conn, {:error, message}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render(SbodaWeb.ErrorView, "error.json", message: message)
  end
end
