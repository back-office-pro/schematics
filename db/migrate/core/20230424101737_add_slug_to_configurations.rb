# frozen_string_literal: true

class AddSlugToConfigurations < ActiveRecord::Migration[7.0]
  def change
    add_column :configurations, :slug, :string
    add_index :configurations,
              :slug,
              unique: true,
              algorithm: :concurrently,
              where: 'deleted_at IS NULL'
  end
end
