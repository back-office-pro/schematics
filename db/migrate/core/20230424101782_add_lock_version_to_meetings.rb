# frozen_string_literal: true

class AddLockVersionToMeetings < ActiveRecord::Migration[7.0]
  def change
    add_column :meetings, :lock_version, :integer
    add_index :meetings, :lock_version, algorithm: :concurrently, where: 'deleted_at IS NULL'
  end
end
