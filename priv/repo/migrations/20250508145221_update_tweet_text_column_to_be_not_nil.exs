defmodule Twitter.Repo.Migrations.UpdateTweetTextColumnToBeNotNil do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    alter table(:tweets) do
      modify :text, :text, null: false
    end
  end

  def down do
    alter table(:tweets) do
      modify :text, :text, null: true
    end
  end
end
