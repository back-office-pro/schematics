# frozen_string_literal: true

class CreateSessions < ActiveRecord::Migration[7.0]
  def change
    create_table :sessions, id: :uuid do |t|
      t.string :auth_token
      t.string :user_agent
      t.string :ip
      t.references :user, index: { where: 'deleted_at IS NULL' }, type: :uuid

      t.timestamps
    end
    add_index :sessions,
              :auth_token,
              algorithm: :concurrently,
              using: :btree,
              where: 'deleted_at IS NULL',
              unique: true
    add_index :sessions,
              :user_agent,
              algorithm: :concurrently,
              using: :btree,
              where: 'deleted_at IS NULL'
    add_index :sessions,
              :ip,
              algorithm: :concurrently,
              using: :btree,
              where: 'deleted_at IS NULL'
  end
end
