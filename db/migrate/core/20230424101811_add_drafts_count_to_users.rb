# frozen_string_literal: true

class AddDraftsCountToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :drafts_count, :integer
    add_index :users, :drafts_count, algorithm: :concurrently, where: 'deleted_at IS NULL'
  end
end
