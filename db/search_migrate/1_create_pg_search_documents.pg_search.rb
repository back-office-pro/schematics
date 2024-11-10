# frozen_string_literal: true

class CreatePgSearchDocuments < ActiveRecord::Migration[7.2]
  def change
    create_table :pg_search_documents, id: :uuid do |t|
      t.text :content
      t.references :searchable, polymorphic: true, index: true, type: :uuid
      t.timestamps null: false
    end
  end
end
