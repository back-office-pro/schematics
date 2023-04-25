# frozen_string_literal: true

class CreateJoinTableApiKeysPermissions < ActiveRecord::Migration[7.0]
  def change
    create_join_table :api_keys, :permissions, column_options: { type: :uuid } do |t|
      t.index %i[api_key_id permission_id], algorithm: :concurrently
      t.index %i[permission_id api_key_id], algorithm: :concurrently
    end
  end
end
