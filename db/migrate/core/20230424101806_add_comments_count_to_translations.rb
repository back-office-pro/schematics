# frozen_string_literal: true

class AddCommentsCountToTranslations < ActiveRecord::Migration[7.0]
  def change
    add_column :translations, :comments_count, :integer
    add_index :translations, :comments_count, algorithm: :concurrently, where: 'deleted_at IS NULL'
  end
end
