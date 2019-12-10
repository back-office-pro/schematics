class CreateSubCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :sub_categories do |t|
      t.string :designation
      t.belongs_to :category, null: false, foreign_key: true

      t.timestamps
    end
    add_index :sub_categories, :designation, unique: true
  end
end
