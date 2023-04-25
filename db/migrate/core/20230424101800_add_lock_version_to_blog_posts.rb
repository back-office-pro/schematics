# frozen_string_literal: true

class AddLockVersionToBlogPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :blog_posts, :lock_version, :integer
    add_index :blog_posts, :lock_version, algorithm: :concurrently, where: 'deleted_at IS NULL'
  end
end
