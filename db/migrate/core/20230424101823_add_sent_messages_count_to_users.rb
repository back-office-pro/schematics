# frozen_string_literal: true

class AddSentMessagesCountToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :sent_messages_count, :integer
    add_index :users, :sent_messages_count, algorithm: :concurrently, where: 'deleted_at IS NULL'
  end
end
