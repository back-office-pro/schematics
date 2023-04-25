# frozen_string_literal: true

class CreateJoinTableTasksUsers < ActiveRecord::Migration[7.0]
  def change
    create_join_table :tasks, :users, column_options: { type: :uuid } do |t|
      t.index %i[task_id user_id], algorithm: :concurrently
      t.index %i[user_id task_id], algorithm: :concurrently
    end
  end
end
