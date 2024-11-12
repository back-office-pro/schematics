# frozen_string_literal: true

class AlterUnaccentFunction < ActiveRecord::Migration[7.2]
  def up
    execute <<~SQL.squish
      ALTER FUNCTION unaccent(regdictionary, text) IMMUTABLE;
      ALTER FUNCTION unaccent(text) IMMUTABLE;
    SQL
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
