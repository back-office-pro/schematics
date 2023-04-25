# frozen_string_literal: true

class AddCommentsCountToApiRequests < ActiveRecord::Migration[7.0]
  def change
    add_column :api_requests, :comments_count, :integer
    add_index :api_requests, :comments_count, algorithm: :concurrently, where: 'deleted_at IS NULL'
  end
end
