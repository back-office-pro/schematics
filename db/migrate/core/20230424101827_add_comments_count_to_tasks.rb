# frozen_string_literal: true

class AddCommentsCountToTasks < ActiveRecord::Migration[7.0]
  def change
    add_column :tasks, :comments_count, :integer
    add_index :tasks, :comments_count, algorithm: :concurrently, where: 'deleted_at IS NULL'
  end
end
