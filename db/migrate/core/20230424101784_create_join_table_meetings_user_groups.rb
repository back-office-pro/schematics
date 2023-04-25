# frozen_string_literal: true

class CreateJoinTableMeetingsUserGroups < ActiveRecord::Migration[7.0]
  def change
    create_join_table :meetings, :user_groups, column_options: { type: :uuid } do |t|
      t.index %i[meeting_id user_group_id], algorithm: :concurrently
      t.index %i[user_group_id meeting_id], algorithm: :concurrently
    end
  end
end
