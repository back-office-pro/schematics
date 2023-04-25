# frozen_string_literal: true

class AddLockVersionToMessages < ActiveRecord::Migration[7.0]
  def change
    add_column :messages, :lock_version, :integer
    add_index :messages, :lock_version, algorithm: :concurrently, where: 'deleted_at IS NULL'
  end
end
