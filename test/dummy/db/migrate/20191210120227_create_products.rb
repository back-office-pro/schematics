class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :designation, limit: 100
      t.string :description
      t.decimal :price, precision: 5, scale: 2
      t.float :vat, default: 19.6
      t.boolean :in_stock, default: false
      t.integer :state, default: 0
      t.belongs_to :sub_category, null: false, foreign_key: true

      t.timestamps
    end
    add_index :products, :designation, unique: true
    add_index :products, :description
    add_index :products, :price
    add_index :products, :vat
    add_index :products, :in_stock
    add_index :products, :state
  end
end
