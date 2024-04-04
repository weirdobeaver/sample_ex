defmodule SampleEx.Repo.Migrations.CreateUsersTable do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string, null: false
      add :email, :string, null: false

      timestamps()
    end

    create index(:users, [:name])
    create unique_index(:users, [:email])
  end
end
