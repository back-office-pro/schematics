class CreateDirectories < ActiveRecord::Migration[6.0]
  def change
    create_table :directories do |t|
      t.string :name
      t.belongs_to :parent, foreign_key: {:to_table=>:directories}

      t.timestamps
    end
    add_index :directories, :name, unique: true
  end
end
