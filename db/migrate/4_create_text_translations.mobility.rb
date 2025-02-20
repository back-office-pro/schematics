# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

class CreateTextTranslations < ActiveRecord::Migration[8.0]
  def change
    create_table :mobility_text_translations do |t|
      t.string :locale, null: false
      t.string :key, null: false
      t.text :value
      t.references :translatable, polymorphic: true, index: false, type: :string
      t.datetime :deleted_at, index: { where: 'deleted_at IS NULL' }
      t.timestamps index: { where: 'deleted_at IS NULL' }
    end
    add_index :mobility_text_translations,
              %i[translatable_id translatable_type locale key],
              name: :index_mobility_text_translations_on_keys,
              where: 'deleted_at IS NULL'
    add_index :mobility_text_translations,
              %i[translatable_id translatable_type key],
              name: :index_mobility_text_translations_on_translatable_attribute,
              where: 'deleted_at IS NULL'
  end
end
