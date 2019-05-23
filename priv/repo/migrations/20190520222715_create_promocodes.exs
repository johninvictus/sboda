defmodule Sboda.Repo.Migrations.CreatePromocodes do
  use Ecto.Migration

  def change do
    # create type
    execute("CREATE TYPE moneyz AS ( cents integer, currently varchar );")
    execute "CREATE EXTENSION IF NOT EXISTS postgis"

    create table(:promocodes) do
      add :title, :string, null: false
      add :distance, :float, null: false

      # date/time when code expires
      add :expir, :naive_datetime, null: false
      add :worth, :moneyz, null: false
      add :active, :boolean, default: true, null: false

      timestamps()
    end

    create(unique_index(:promocodes, [:title]))
    # This can store a "standard GPS" (epsg4326) coordinate pair {longitude,latitude}.
    execute("SELECT AddGeometryColumn ('promocodes','point',4326,'POINT',2)")

    # Indexed the point, this will ensure the query runs fast even when dealing with large data sets.
    execute("CREATE INDEX promocodes_point_index on promocodes USING gist (point)")
  end
end
