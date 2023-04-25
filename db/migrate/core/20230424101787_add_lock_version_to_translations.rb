# frozen_string_literal: true

class AddLockVersionToTranslations < ActiveRecord::Migration[7.0]
  def change
    add_column :translations, :lock_version, :integer
    add_index :translations, :lock_version, algorithm: :concurrently, where: 'deleted_at IS NULL'
  end
end
