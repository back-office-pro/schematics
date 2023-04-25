# frozen_string_literal: true

class AddLockVersionToSearches < ActiveRecord::Migration[7.0]
  def change
    add_column :searches, :lock_version, :integer
    add_index :searches, :lock_version, algorithm: :concurrently, where: 'deleted_at IS NULL'
  end
end
