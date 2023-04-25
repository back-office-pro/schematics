# frozen_string_literal: true

class AddApiRequestsCountToApiKeys < ActiveRecord::Migration[7.0]
  def change
    add_column :api_keys, :api_requests_count, :integer
    add_index :api_keys, :api_requests_count, algorithm: :concurrently, where: 'deleted_at IS NULL'
  end
end
