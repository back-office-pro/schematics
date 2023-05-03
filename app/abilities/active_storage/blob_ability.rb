# frozen_string_literal: true

module ActiveStorage
  class BlobAbility < Schematics::ApplicationAbility
    def initialize
      super
      cannot :read, ::ActiveStorage::Blob, filename: %w[.env master.key db.dump]
    end
  end
end
