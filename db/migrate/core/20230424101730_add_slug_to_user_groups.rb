# frozen_string_literal: true

class AddSlugToUserGroups < ActiveRecord::Migration[7.0]
  def change
    add_column :user_groups, :slug, :string
    add_index :user_groups,
              :slug,
              unique: true,
              algorithm: :concurrently,
              where: 'deleted_at IS NULL'
  end
end
