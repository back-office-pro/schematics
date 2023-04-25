# frozen_string_literal: true

class AddSessionsCountToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :sessions_count, :integer
    add_index :users, :sessions_count, algorithm: :concurrently, where: 'deleted_at IS NULL'
  end
end
