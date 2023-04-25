# frozen_string_literal: true

class AddSlugToComments < ActiveRecord::Migration[7.0]
  def change
    add_column :comments, :slug, :string
    add_index :comments, :slug, unique: true, algorithm: :concurrently, where: 'deleted_at IS NULL'
  end
end
