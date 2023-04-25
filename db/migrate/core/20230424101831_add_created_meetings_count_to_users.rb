# frozen_string_literal: true

class AddCreatedMeetingsCountToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :created_meetings_count, :integer
    add_index :users, :created_meetings_count, algorithm: :concurrently, where: 'deleted_at IS NULL'
  end
end
