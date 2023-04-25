# frozen_string_literal: true

class AddLockVersionToComments < ActiveRecord::Migration[7.0]
  def change
    add_column :comments, :lock_version, :integer
    add_index :comments, :lock_version, algorithm: :concurrently, where: 'deleted_at IS NULL'
  end
end
