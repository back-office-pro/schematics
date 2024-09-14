# frozen_string_literal: true

module ActiveStorage
  class BlobAbility < Schematics::ApplicationAbility
    def initialize
      super
      cannot :read, ::ActiveStorage::Blob, filename: 'master.key'
      cannot :read, ::ActiveStorage::Blob, attachments: { name: 'preview_image' }
    end
  end
end
