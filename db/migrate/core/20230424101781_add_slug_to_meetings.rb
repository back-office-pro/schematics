# frozen_string_literal: true

class AddSlugToMeetings < ActiveRecord::Migration[7.0]
  def change
    add_column :meetings, :slug, :string
    add_index :meetings, :slug, unique: true, algorithm: :concurrently, where: 'deleted_at IS NULL'
  end
end
