# frozen_string_literal: true

class AddLockVersionToTasks < ActiveRecord::Migration[7.0]
  def change
    add_column :tasks, :lock_version, :integer
    add_index :tasks, :lock_version, algorithm: :concurrently, where: 'deleted_at IS NULL'
  end
end
