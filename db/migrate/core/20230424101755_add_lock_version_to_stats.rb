# frozen_string_literal: true

class AddLockVersionToStats < ActiveRecord::Migration[7.0]
  def change
    add_column :stats, :lock_version, :integer
    add_index :stats, :lock_version, algorithm: :concurrently, where: 'deleted_at IS NULL'
  end
end
