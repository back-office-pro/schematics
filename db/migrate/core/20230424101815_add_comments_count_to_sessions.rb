# frozen_string_literal: true

class AddCommentsCountToSessions < ActiveRecord::Migration[7.0]
  def change
    add_column :sessions, :comments_count, :integer
    add_index :sessions, :comments_count, algorithm: :concurrently, where: 'deleted_at IS NULL'
  end
end
