# frozen_string_literal: true

class AddRequestedTasksCountToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :requested_tasks_count, :integer
    add_index :users, :requested_tasks_count, algorithm: :concurrently, where: 'deleted_at IS NULL'
  end
end
