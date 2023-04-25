# frozen_string_literal: true

class AddLockVersionToCharts < ActiveRecord::Migration[7.0]
  def change
    add_column :charts, :lock_version, :integer
    add_index :charts, :lock_version, algorithm: :concurrently, where: 'deleted_at IS NULL'
  end
end
