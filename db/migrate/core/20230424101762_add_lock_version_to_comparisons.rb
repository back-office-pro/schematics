# frozen_string_literal: true

class AddLockVersionToComparisons < ActiveRecord::Migration[7.0]
  def change
    add_column :comparisons, :lock_version, :integer
    add_index :comparisons, :lock_version, algorithm: :concurrently, where: 'deleted_at IS NULL'
  end
end
