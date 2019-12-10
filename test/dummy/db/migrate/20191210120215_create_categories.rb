class CreateCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :categories do |t|
      t.string :designation, null: false

      t.timestamps
    end
    add_index :categories, :designation, unique: true
  end
end
