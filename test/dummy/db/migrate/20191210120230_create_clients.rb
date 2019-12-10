class CreateClients < ActiveRecord::Migration[6.0]
  def change
    create_table :clients do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false

      t.timestamps
    end
    add_index :clients, :first_name
    add_index :clients, :last_name
  end
end
