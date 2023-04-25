# frozen_string_literal: true

class CreateApiRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :api_requests, id: :uuid do |t|
      t.belongs_to :api_key, index: { where: 'deleted_at IS NULL' }, type: :uuid
      t.string :ip
      t.string :endpoint
      t.integer :request_method

      t.timestamps
    end
    add_index :api_requests,
              :ip,
              algorithm: :concurrently,
              using: :btree,
              where: 'deleted_at IS NULL'
    add_index :api_requests,
              :endpoint,
              algorithm: :concurrently,
              using: :btree,
              where: 'deleted_at IS NULL'
    add_index :api_requests,
              :request_method,
              algorithm: :concurrently,
              using: :btree,
              where: 'deleted_at IS NULL'
  end
end
