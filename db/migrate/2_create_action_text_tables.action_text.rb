# frozen_string_literal: true

class CreateActionTextTables < ActiveRecord::Migration[6.1] # rubocop:disable Rails/MigrationClassName
  def change
    create_table :action_text_rich_texts, id: :uuid do |t|
      t.string     :name, null: false
      t.text       :body, size: :long
      t.references :record, null: false, polymorphic: true, index: false, type: :uuid

      t.timestamps

      t.index %i[record_type record_id name],
              name: 'index_action_text_rich_texts_uniqueness',
              unique: true
    end
  end
end
