# frozen_string_literal: true

class AddSlugToStats < ActiveRecord::Migration[7.0]
  def change
    add_column :stats, :slug, :string
    add_index :stats, :slug, unique: true, algorithm: :concurrently, where: 'deleted_at IS NULL'
  end
end
