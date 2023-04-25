# frozen_string_literal: true

class AddSlugToTranslations < ActiveRecord::Migration[7.0]
  def change
    add_column :translations, :slug, :string
    add_index :translations,
              :slug,
              unique: true,
              algorithm: :concurrently,
              where: 'deleted_at IS NULL'
  end
end
