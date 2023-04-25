# frozen_string_literal: true

class CreateBlogPosts < ActiveRecord::Migration[7.0]
  def change
    create_table :blog_posts, id: :uuid do |t|
      t.citext :title
      t.integer :state
      t.references :author, index: { where: 'deleted_at IS NULL' }, type: :uuid

      t.timestamps
    end
    add_index :blog_posts,
              :title,
              unique: true,
              algorithm: :concurrently,
              using: :btree,
              where: 'deleted_at IS NULL'
    add_index :blog_posts,
              :state,
              algorithm: :concurrently,
              using: :btree,
              where: 'deleted_at IS NULL'
  end
end
