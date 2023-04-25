# frozen_string_literal: true

class AddCommentsCountToPermissions < ActiveRecord::Migration[7.0]
  def change
    add_column :permissions, :comments_count, :integer
    add_index :permissions, :comments_count, algorithm: :concurrently, where: 'deleted_at IS NULL'
  end
end
