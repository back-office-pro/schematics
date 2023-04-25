# frozen_string_literal: true

class CreateJoinTableMeetingsUsers < ActiveRecord::Migration[7.0]
  def change
    create_join_table :meetings, :users, column_options: { type: :uuid } do |t|
      t.index %i[meeting_id user_id], algorithm: :concurrently
      t.index %i[user_id meeting_id], algorithm: :concurrently
    end
  end
end
