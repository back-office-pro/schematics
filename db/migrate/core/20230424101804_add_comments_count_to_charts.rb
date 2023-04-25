# frozen_string_literal: true

class AddCommentsCountToCharts < ActiveRecord::Migration[7.0]
  def change
    add_column :charts, :comments_count, :integer
    add_index :charts, :comments_count, algorithm: :concurrently, where: 'deleted_at IS NULL'
  end
end
