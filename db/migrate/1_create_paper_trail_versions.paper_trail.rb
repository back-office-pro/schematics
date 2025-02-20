# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

class CreatePaperTrailVersions < ActiveRecord::Migration[8.0]
  def change
    create_table :paper_trail_versions, id: :string do |t|
      t.references :item, polymorphic: true, type: :string, index: false
      t.string     :event,     null: false
      t.string     :whodunnit, null: false
      t.jsonb      :object
      t.jsonb      :object_changes

      t.timestamps
    end
    add_index :paper_trail_versions, %i[item_type item_id]
  end
end
