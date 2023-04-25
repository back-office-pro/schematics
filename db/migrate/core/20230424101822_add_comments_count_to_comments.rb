# frozen_string_literal: true

class AddCommentsCountToComments < ActiveRecord::Migration[7.0]
  def change
    add_column :comments, :comments_count, :integer
    add_index :comments, :comments_count, algorithm: :concurrently, where: 'deleted_at IS NULL'
  end
end
