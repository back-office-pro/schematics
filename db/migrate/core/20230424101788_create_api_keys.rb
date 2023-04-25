# frozen_string_literal: true

class CreateApiKeys < ActiveRecord::Migration[7.0]
  def change
    create_table :api_keys, id: :uuid do |t|
      t.citext :name
      t.string :auth_token
      t.datetime :expires_at

      t.timestamps
    end
    add_index :api_keys,
              :auth_token,
              algorithm: :concurrently,
              using: :btree,
              where: 'deleted_at IS NULL',
              unique: true
    add_index :api_keys,
              :name,
              unique: true,
              algorithm: :concurrently,
              using: :btree,
              where: 'deleted_at IS NULL'
    add_index :api_keys,
              :expires_at,
              algorithm: :concurrently,
              using: :btree,
              where: 'deleted_at IS NULL'
  end
end
