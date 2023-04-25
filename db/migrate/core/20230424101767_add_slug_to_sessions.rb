# frozen_string_literal: true

class AddSlugToSessions < ActiveRecord::Migration[7.0]
  def change
    add_column :sessions, :slug, :string
    add_index :sessions, :slug, unique: true, algorithm: :concurrently, where: 'deleted_at IS NULL'
  end
end
