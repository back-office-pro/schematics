# frozen_string_literal: true

class AddCommentsCountToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :comments_count, :integer
    add_index :users, :comments_count, algorithm: :concurrently, where: 'deleted_at IS NULL'
  end
end
