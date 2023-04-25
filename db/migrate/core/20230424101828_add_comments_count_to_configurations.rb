# frozen_string_literal: true

class AddCommentsCountToConfigurations < ActiveRecord::Migration[7.0]
  def change
    add_column :configurations, :comments_count, :integer
    add_index :configurations,
              :comments_count,
              algorithm: :concurrently,
              where: 'deleted_at IS NULL'
  end
end
