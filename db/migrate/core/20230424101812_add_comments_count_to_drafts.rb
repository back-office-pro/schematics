# frozen_string_literal: true

class AddCommentsCountToDrafts < ActiveRecord::Migration[7.0]
  def change
    add_column :drafts, :comments_count, :integer
    add_index :drafts, :comments_count, algorithm: :concurrently, where: 'deleted_at IS NULL'
  end
end
