# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users, id: :uuid do |t|
      t.citext :email
      t.string :password_digest
      t.string :password_reset_token
      t.string :first_name
      t.string :last_name
      t.integer :locale
      t.string :time_zone
      t.jsonb :preferences
      t.belongs_to :role, index: { where: 'deleted_at IS NULL' }, type: :uuid
      t.datetime :read_notifications_at
      t.datetime :reset_password_sent_at

      t.timestamps
    end
    add_index :users,
              :password_reset_token,
              algorithm: :concurrently,
              using: :btree,
              where: 'deleted_at IS NULL',
              unique: true
    add_index :users,
              :email,
              unique: true,
              algorithm: :concurrently,
              using: :btree,
              where: 'deleted_at IS NULL'
    add_index :users,
              :first_name,
              algorithm: :concurrently,
              using: :btree,
              where: 'deleted_at IS NULL'
    add_index :users,
              :last_name,
              algorithm: :concurrently,
              using: :btree,
              where: 'deleted_at IS NULL'
    add_index :users,
              :locale,
              algorithm: :concurrently,
              using: :btree,
              where: 'deleted_at IS NULL'
    add_index :users,
              :time_zone,
              algorithm: :concurrently,
              using: :btree,
              where: 'deleted_at IS NULL'
    add_index :users,
              :preferences,
              algorithm: :concurrently,
              using: :gin,
              where: 'deleted_at IS NULL'
    add_index :users,
              :read_notifications_at,
              algorithm: :concurrently,
              using: :btree,
              where: 'deleted_at IS NULL'
    add_index :users,
              :reset_password_sent_at,
              algorithm: :concurrently,
              using: :btree,
              where: 'deleted_at IS NULL'
  end
end
