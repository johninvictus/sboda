defmodule Sboda.Repo.Migrations.CreatePromocodes do
  use Ecto.Migration

  def change do
    # create type
    execute("CREATE TYPE moneyz AS ( cents integer, currently varchar );")
    execute("CREATE TYPE gex AS ( latitude float, longitude float );")

    create table(:promocodes) do
      add :title, :string, null: false
      add :distance, :float, null: false

      # date/time when code expires
      add :expir, :naive_datetime, null: false
      add :worth, :moneyz, null: false
      add :point, :gex
      add :active, :boolean, default: true, null: false

      timestamps()
    end

    create(unique_index(:promocodes, [:title]))
  end
end
