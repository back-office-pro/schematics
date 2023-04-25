# frozen_string_literal: true

class CreateJoinTableStatsRoles < ActiveRecord::Migration[7.0]
  def change
    create_join_table :stats, :roles, column_options: { type: :uuid } do |t|
      t.index %i[stat_id role_id], algorithm: :concurrently
      t.index %i[role_id stat_id], algorithm: :concurrently
    end
  end
end
