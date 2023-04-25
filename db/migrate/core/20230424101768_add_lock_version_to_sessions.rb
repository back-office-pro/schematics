# frozen_string_literal: true

class AddLockVersionToSessions < ActiveRecord::Migration[7.0]
  def change
    add_column :sessions, :lock_version, :integer
    add_index :sessions, :lock_version, algorithm: :concurrently, where: 'deleted_at IS NULL'
  end
end
