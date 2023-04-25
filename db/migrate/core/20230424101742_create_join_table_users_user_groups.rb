# frozen_string_literal: true

class CreateJoinTableUsersUserGroups < ActiveRecord::Migration[7.0]
  def change
    create_join_table :users, :user_groups, column_options: { type: :uuid } do |t|
      t.index %i[user_id user_group_id], algorithm: :concurrently
      t.index %i[user_group_id user_id], algorithm: :concurrently
    end
  end
end
