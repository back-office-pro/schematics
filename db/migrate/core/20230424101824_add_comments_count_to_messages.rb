# frozen_string_literal: true

class AddCommentsCountToMessages < ActiveRecord::Migration[7.0]
  def change
    add_column :messages, :comments_count, :integer
    add_index :messages, :comments_count, algorithm: :concurrently, where: 'deleted_at IS NULL'
  end
end
