# frozen_string_literal: true

class AddBlogPostsCountToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :blog_posts_count, :integer
    add_index :users, :blog_posts_count, algorithm: :concurrently, where: 'deleted_at IS NULL'
  end
end
