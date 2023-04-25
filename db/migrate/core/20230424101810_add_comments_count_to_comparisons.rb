# frozen_string_literal: true

class AddCommentsCountToComparisons < ActiveRecord::Migration[7.0]
  def change
    add_column :comparisons, :comments_count, :integer
    add_index :comparisons, :comments_count, algorithm: :concurrently, where: 'deleted_at IS NULL'
  end
end
