# frozen_string_literal: true

class AddUsersCountToRoles < ActiveRecord::Migration[7.0]
  def change
    add_column :roles, :users_count, :integer
    add_index :roles, :users_count, algorithm: :concurrently, where: 'deleted_at IS NULL'
  end
end
