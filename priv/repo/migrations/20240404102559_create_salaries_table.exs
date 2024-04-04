defmodule SampleEx.Repo.Migrations.CreateSalariesTable do
  use Ecto.Migration

  def change do
    create table(:salaries) do
      add :amount, :decimal, null: false
      add :currency, :string, null: false
      add :active, :boolean, default: false
      add :user_id, references(:users), primary_key: true

      timestamps(type: :utc_datetime_usec)
    end

    create index(:salaries, [:user_id])

    create index(:salaries, [:active, :user_id],
             name: "salaries_active_user_id_idx",
             unique: true,
             where: "active IS TRUE"
           )
  end
end
