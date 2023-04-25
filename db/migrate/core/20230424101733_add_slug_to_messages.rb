# frozen_string_literal: true

class AddSlugToMessages < ActiveRecord::Migration[7.0]
  def change
    add_column :messages, :slug, :string
    add_index :messages, :slug, unique: true, algorithm: :concurrently, where: 'deleted_at IS NULL'
  end
end
