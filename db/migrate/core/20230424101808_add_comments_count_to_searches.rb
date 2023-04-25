# frozen_string_literal: true

class AddCommentsCountToSearches < ActiveRecord::Migration[7.0]
  def change
    add_column :searches, :comments_count, :integer
    add_index :searches, :comments_count, algorithm: :concurrently, where: 'deleted_at IS NULL'
  end
end
