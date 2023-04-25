# frozen_string_literal: true

class AddImportsCountToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :imports_count, :integer
    add_index :users, :imports_count, algorithm: :concurrently, where: 'deleted_at IS NULL'
  end
end
