# frozen_string_literal: true

class CreateTranslations < ActiveRecord::Migration[7.0]
  def change
    create_table :translations, id: :uuid do |t|
      t.integer :locale
      t.string :key
      t.string :value

      t.timestamps
    end
    add_index :translations,
              :locale,
              algorithm: :concurrently,
              using: :btree,
              where: 'deleted_at IS NULL'
    add_index :translations,
              :key,
              algorithm: :concurrently,
              using: :btree,
              where: 'deleted_at IS NULL'
    add_index :translations,
              :value,
              algorithm: :concurrently,
              using: :btree,
              where: 'deleted_at IS NULL'
  end
end
