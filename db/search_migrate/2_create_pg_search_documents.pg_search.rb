# frozen_string_literal: true

class CreatePgSearchDocuments < ActiveRecord::Migration[7.2]
  def change
    create_table :pg_search_documents, id: :uuid do |t|
      t.text :content
      t.references :searchable, polymorphic: true, index: true, type: :uuid
      t.timestamps null: false
    end
    add_index :pg_search_documents,
              %[
                to_tsvector(
                  'simple',
                  immutable_unaccent(coalesce(("pg_search_documents"."content")::text, ''))
                )
              ],
              using: :gin,
              name: :index_pg_search_documents_on_content
  end
end
