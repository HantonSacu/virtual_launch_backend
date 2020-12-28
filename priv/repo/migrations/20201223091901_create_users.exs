defmodule MpgSamsungLaunch.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def up do
    execute "CREATE EXTENSION IF NOT EXISTS citext;"

    create table(:users) do
      add :email, :citext, null: false
      add :first_name, :string
      add :last_name, :string

      timestamps()
    end

    create unique_index(:users, [:email])
  end

  def down do
    drop unique_index(:users, [:email])

    drop table(:users)

    execute "DROP EXTENSION citext;"
  end
end
