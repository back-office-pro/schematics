# frozen_string_literal: true

class CreateJoinTableMessagesUsers < ActiveRecord::Migration[7.0]
  def change
    create_join_table :messages, :users, column_options: { type: :uuid } do |t|
      t.index %i[message_id user_id], algorithm: :concurrently
      t.index %i[user_id message_id], algorithm: :concurrently
    end
  end
end
