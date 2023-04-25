# frozen_string_literal: true

class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks, id: :uuid do |t|
      t.string :title
      t.references :applicant, index: { where: 'deleted_at IS NULL' }, type: :uuid
      t.datetime :deadline
      t.integer :state

      t.timestamps
    end
    add_index :tasks,
              :title,
              algorithm: :concurrently,
              using: :btree,
              where: 'deleted_at IS NULL'
    add_index :tasks,
              :deadline,
              algorithm: :concurrently,
              using: :btree,
              where: 'deleted_at IS NULL'
    add_index :tasks,
              :state,
              algorithm: :concurrently,
              using: :btree,
              where: 'deleted_at IS NULL'
  end
end
