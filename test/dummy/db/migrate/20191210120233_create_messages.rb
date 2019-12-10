class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.string :subject, null: false
      t.belongs_to :author, null: false, foreign_key: {:to_table=>:users}
      t.belongs_to :recipient, null: false, foreign_key: {:to_table=>:users}

      t.timestamps
    end
    add_index :messages, :subject
  end
end
