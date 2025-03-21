# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module ActiveStorage
  class BlobAbility < Schematics::ApplicationAbility
    def initialize
      super
      cannot :read, ::ActiveStorage::Blob, attachments: { name: 'preview_image' }
      cannot :read, ::ActiveStorage::Blob, attachments: { record_type: 'Backup' }
      cannot :read, ::ActiveStorage::Blob, attachments: { record_type: 'LinkPreview' }
    end
  end
end
