defmodule Quicklist.Repo.Migrations.CreateTodos do
  use Ecto.Migration

  # mix phx.gen.schema Todo todos title:string completed:boolean --timestamps
  def change do
    create table(:todos) do
      add :title, :string
      add :completed, :boolean, default: false, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
