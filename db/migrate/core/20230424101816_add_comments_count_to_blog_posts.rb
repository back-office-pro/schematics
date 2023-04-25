# frozen_string_literal: true

class AddCommentsCountToBlogPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :blog_posts, :comments_count, :integer
    add_index :blog_posts, :comments_count, algorithm: :concurrently, where: 'deleted_at IS NULL'
  end
end
