# frozen_string_literal: true

class AddSlugToLicences < ActiveRecord::Migration[7.0]
  def change
    add_column :licences, :slug, :string
    add_index :licences, :slug, unique: true, algorithm: :concurrently, where: 'deleted_at IS NULL'
  end
end
