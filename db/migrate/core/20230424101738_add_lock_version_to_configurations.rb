# frozen_string_literal: true

class AddLockVersionToConfigurations < ActiveRecord::Migration[7.0]
  def change
    add_column :configurations, :lock_version, :integer
    add_index :configurations, :lock_version, algorithm: :concurrently, where: 'deleted_at IS NULL'
  end
end
