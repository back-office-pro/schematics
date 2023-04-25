# frozen_string_literal: true

class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages, id: :uuid do |t|
      t.string :subject
      t.references :author, index: { where: 'deleted_at IS NULL' }, type: :uuid

      t.timestamps
    end
    add_index :messages,
              :subject,
              algorithm: :concurrently,
              using: :btree,
              where: 'deleted_at IS NULL'
  end
end
