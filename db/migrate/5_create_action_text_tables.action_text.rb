# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

class CreateActionTextTables < ActiveRecord::Migration[7.0]
  def change
    create_table :action_text_rich_texts, id: :string do |t|
      t.string     :name, null: false
      t.text       :body, size: :long
      t.string     :locale
      t.references :record, null: false, polymorphic: true, index: false, type: :string
      t.datetime   :deleted_at, index: { where: 'deleted_at IS NULL' }

      t.timestamps index: { where: 'deleted_at IS NULL' }

      t.index %i[record_type record_id name locale],
              name: :index_action_text_rich_texts_uniqueness,
              unique: true,
              where: 'deleted_at IS NULL'
    end
  end
end
