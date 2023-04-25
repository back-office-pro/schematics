# frozen_string_literal: true

class CreateDrafts < ActiveRecord::Migration[7.0]
  def change
    create_table :drafts, id: :uuid do |t|
      t.string :action
      t.jsonb :data
      t.references :user, index: { where: 'deleted_at IS NULL' }, type: :uuid

      t.timestamps
    end
    add_index :drafts, :action, algorithm: :concurrently, using: :btree, where: 'deleted_at IS NULL'
    add_index :drafts, :data, algorithm: :concurrently, using: :gin, where: 'deleted_at IS NULL'
  end
end
