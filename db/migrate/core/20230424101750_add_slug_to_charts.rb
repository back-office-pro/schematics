# frozen_string_literal: true

class AddSlugToCharts < ActiveRecord::Migration[7.0]
  def change
    add_column :charts, :slug, :string
    add_index :charts, :slug, unique: true, algorithm: :concurrently, where: 'deleted_at IS NULL'
  end
end
