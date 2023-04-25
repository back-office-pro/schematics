# frozen_string_literal: true

class CreateMeetings < ActiveRecord::Migration[7.0]
  def change
    create_table :meetings, id: :uuid do |t|
      t.string :subject
      t.references :creator, index: { where: 'deleted_at IS NULL' }, type: :uuid
      t.datetime :start_at
      t.datetime :end_at
      t.citext :url
      t.string :location

      t.timestamps
    end
    add_index :meetings,
              :subject,
              algorithm: :concurrently,
              using: :btree,
              where: 'deleted_at IS NULL'
    add_index :meetings,
              :start_at,
              algorithm: :concurrently,
              using: :btree,
              where: 'deleted_at IS NULL'
    add_index :meetings,
              :end_at,
              algorithm: :concurrently,
              using: :btree,
              where: 'deleted_at IS NULL'
    add_index :meetings,
              :url,
              algorithm: :concurrently,
              using: :btree,
              where: 'deleted_at IS NULL'
    add_index :meetings,
              :location,
              algorithm: :concurrently,
              using: :btree,
              where: 'deleted_at IS NULL'
  end
end
