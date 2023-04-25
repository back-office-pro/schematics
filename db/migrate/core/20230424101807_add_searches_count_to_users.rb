# frozen_string_literal: true

class AddSearchesCountToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :searches_count, :integer
    add_index :users, :searches_count, algorithm: :concurrently, where: 'deleted_at IS NULL'
  end
end
