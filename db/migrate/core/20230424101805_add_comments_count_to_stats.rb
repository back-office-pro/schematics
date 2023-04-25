# frozen_string_literal: true

class AddCommentsCountToStats < ActiveRecord::Migration[7.0]
  def change
    add_column :stats, :comments_count, :integer
    add_index :stats, :comments_count, algorithm: :concurrently, where: 'deleted_at IS NULL'
  end
end
