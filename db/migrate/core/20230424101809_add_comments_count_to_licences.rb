# frozen_string_literal: true

class AddCommentsCountToLicences < ActiveRecord::Migration[7.0]
  def change
    add_column :licences, :comments_count, :integer
    add_index :licences, :comments_count, algorithm: :concurrently, where: 'deleted_at IS NULL'
  end
end
