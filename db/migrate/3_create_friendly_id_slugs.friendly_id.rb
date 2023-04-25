# frozen_string_literal: true

class CreateFriendlyIdSlugs < ActiveRecord::Migration[7.0]
  def change
    create_table :friendly_id_slugs, id: :uuid do |t|
      t.string   :slug,           null: false
      t.uuid     :sluggable_id,   null: false
      t.string   :sluggable_type, limit: 50
      t.string   :scope
      t.string   :locale, null: false
      t.datetime :created_at
    end
    add_index :friendly_id_slugs, :locale
    add_index :friendly_id_slugs, %i[sluggable_type sluggable_id]
    add_index :friendly_id_slugs,
              %i[slug sluggable_type locale],
              length: { slug: 140, sluggable_type: 50, locale: 2 }
    add_index :friendly_id_slugs,
              %i[slug sluggable_type scope locale],
              length: { slug: 70, sluggable_type: 50, scope: 70, locale: 2 },
              name: :index_friendly_id_slugs_unique,
              unique: true
  end
end
