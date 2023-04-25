# frozen_string_literal: true

class CreateJoinTableChartsRoles < ActiveRecord::Migration[7.0]
  def change
    create_join_table :charts, :roles, column_options: { type: :uuid } do |t|
      t.index %i[chart_id role_id], algorithm: :concurrently
      t.index %i[role_id chart_id], algorithm: :concurrently
    end
  end
end
