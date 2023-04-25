# frozen_string_literal: true

class CreateConfigurations < ActiveRecord::Migration[7.0]
  def change
    create_table :configurations, id: :uuid do |t|
      t.string :company_name
      t.string :company_address
      t.citext :company_website
      t.string :company_registration_number
      t.integer :locale
      t.string :time_zone
      t.string :theme_color
      t.boolean :messages_feature_flag # rubocop:disable Rails/ThreeStateBooleanColumn
      t.boolean :comments_feature_flag # rubocop:disable Rails/ThreeStateBooleanColumn
      t.boolean :tasks_feature_flag # rubocop:disable Rails/ThreeStateBooleanColumn
      t.boolean :meetings_feature_flag # rubocop:disable Rails/ThreeStateBooleanColumn
      t.boolean :blog_feature_flag # rubocop:disable Rails/ThreeStateBooleanColumn

      t.timestamps
    end
    add_index :configurations,
              :company_name,
              algorithm: :concurrently,
              using: :btree,
              where: 'deleted_at IS NULL'
    add_index :configurations,
              :company_address,
              algorithm: :concurrently,
              using: :btree,
              where: 'deleted_at IS NULL'
    add_index :configurations,
              :company_website,
              algorithm: :concurrently,
              using: :btree,
              where: 'deleted_at IS NULL'
    add_index :configurations,
              :company_registration_number,
              algorithm: :concurrently,
              using: :btree,
              where: 'deleted_at IS NULL'
    add_index :configurations,
              :locale,
              algorithm: :concurrently,
              using: :btree,
              where: 'deleted_at IS NULL'
    add_index :configurations,
              :time_zone,
              algorithm: :concurrently,
              using: :btree,
              where: 'deleted_at IS NULL'
    add_index :configurations,
              :theme_color,
              algorithm: :concurrently,
              using: :btree,
              where: 'deleted_at IS NULL'
    add_index :configurations,
              :messages_feature_flag,
              algorithm: :concurrently,
              using: :btree,
              where: 'deleted_at IS NULL'
    add_index :configurations,
              :comments_feature_flag,
              algorithm: :concurrently,
              using: :btree,
              where: 'deleted_at IS NULL'
    add_index :configurations,
              :tasks_feature_flag,
              algorithm: :concurrently,
              using: :btree,
              where: 'deleted_at IS NULL'
    add_index :configurations,
              :meetings_feature_flag,
              algorithm: :concurrently,
              using: :btree,
              where: 'deleted_at IS NULL'
    add_index :configurations,
              :blog_feature_flag,
              algorithm: :concurrently,
              using: :btree,
              where: 'deleted_at IS NULL'
  end
end
