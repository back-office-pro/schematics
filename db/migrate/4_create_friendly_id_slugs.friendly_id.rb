class CreateFriendlyIdSlugs < ActiveRecord::Migration[6.0]
  def change
    create_table :friendly_id_slugs, id: :uuid do |t|
      t.string   :slug,           null: false
      t.uuid     :sluggable_id,   null: false
      t.string   :sluggable_type, null: false
      t.string   :scope
      t.datetime :created_at
    end
    add_index :friendly_id_slugs, [:sluggable_type, :sluggable_id]
    add_index :friendly_id_slugs, [:slug, :sluggable_type, :scope], unique: true
  end
end
