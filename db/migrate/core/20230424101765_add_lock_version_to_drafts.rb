# frozen_string_literal: true

class AddLockVersionToDrafts < ActiveRecord::Migration[7.0]
  def change
    add_column :drafts, :lock_version, :integer
    add_index :drafts, :lock_version, algorithm: :concurrently, where: 'deleted_at IS NULL'
  end
end
