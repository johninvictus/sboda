defmodule Sboda.Repo do
  use Ecto.Repo,
    otp_app: :sboda,
    adapter: Ecto.Adapters.Postgres
end
