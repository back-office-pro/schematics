# frozen_string_literal: true

class AddLockVersionToLicences < ActiveRecord::Migration[7.0]
  def change
    add_column :licences, :lock_version, :integer
    add_index :licences, :lock_version, algorithm: :concurrently, where: 'deleted_at IS NULL'
  end
end
