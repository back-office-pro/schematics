# frozen_string_literal: true

class AddLockVersionToImports < ActiveRecord::Migration[7.0]
  def change
    add_column :imports, :lock_version, :integer
    add_index :imports, :lock_version, algorithm: :concurrently, where: 'deleted_at IS NULL'
  end
end
