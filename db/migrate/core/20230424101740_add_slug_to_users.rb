# frozen_string_literal: true

class AddSlugToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :slug, :string
    add_index :users, :slug, unique: true, algorithm: :concurrently, where: 'deleted_at IS NULL'
  end
end
