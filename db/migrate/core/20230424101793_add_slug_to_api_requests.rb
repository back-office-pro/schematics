# frozen_string_literal: true

class AddSlugToApiRequests < ActiveRecord::Migration[7.0]
  def change
    add_column :api_requests, :slug, :string
    add_index :api_requests,
              :slug,
              unique: true,
              algorithm: :concurrently,
              where: 'deleted_at IS NULL'
  end
end
