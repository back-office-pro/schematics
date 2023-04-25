# frozen_string_literal: true

class AddCommentsCountToRoles < ActiveRecord::Migration[7.0]
  def change
    add_column :roles, :comments_count, :integer
    add_index :roles, :comments_count, algorithm: :concurrently, where: 'deleted_at IS NULL'
  end
end
