# frozen_string_literal: true

class CreateUserGroups < ActiveRecord::Migration[7.0]
  def change
    create_table :user_groups, id: :uuid do |t|
      t.citext :name

      t.timestamps
    end
    add_index :user_groups,
              :name,
              unique: true,
              algorithm: :concurrently,
              using: :btree,
              where: 'deleted_at IS NULL'
  end
end
