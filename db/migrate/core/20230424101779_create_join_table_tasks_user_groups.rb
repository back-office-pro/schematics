# frozen_string_literal: true

class CreateJoinTableTasksUserGroups < ActiveRecord::Migration[7.0]
  def change
    create_join_table :tasks, :user_groups, column_options: { type: :uuid } do |t|
      t.index %i[task_id user_group_id], algorithm: :concurrently
      t.index %i[user_group_id task_id], algorithm: :concurrently
    end
  end
end
