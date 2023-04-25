# frozen_string_literal: true

class CreateJoinTableRolesPermissions < ActiveRecord::Migration[7.0]
  def change
    create_join_table :roles, :permissions, column_options: { type: :uuid } do |t|
      t.index %i[role_id permission_id], algorithm: :concurrently
      t.index %i[permission_id role_id], algorithm: :concurrently
    end
  end
end
