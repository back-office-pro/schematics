# frozen_string_literal: true

class AddSlugToApiKeys < ActiveRecord::Migration[7.0]
  def change
    add_column :api_keys, :slug, :string
    add_index :api_keys, :slug, unique: true, algorithm: :concurrently, where: 'deleted_at IS NULL'
  end
end
