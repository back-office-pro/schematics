# frozen_string_literal: true

class CreatePaperTrailVersions < ActiveRecord::Migration[7.1]
  def change
    create_table :paper_trail_versions, id: :uuid do |t|
      t.string   :item_type, null: false
      t.uuid     :item_id,   null: false
      t.string   :event,     null: false
      t.uuid     :whodunnit, null: false
      t.jsonb    :object
      t.jsonb    :object_changes

      t.timestamps
    end
    add_index :paper_trail_versions, %i[item_type item_id]
  end
end
