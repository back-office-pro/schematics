# frozen_string_literal: true

class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments, id: :uuid do |t|
      t.belongs_to :record, index: { where: 'deleted_at IS NULL' }, polymorphic: true, type: :uuid
      t.references :author, index: { where: 'deleted_at IS NULL' }, type: :uuid

      t.timestamps
    end
  end
end
