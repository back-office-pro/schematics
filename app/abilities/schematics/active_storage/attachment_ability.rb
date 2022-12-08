# frozen_string_literal: true

module Schematics
  module ActiveStorage
    class AttachmentAbility < ApplicationAbility
      def initialize(user, mod)
        super
        cannot :destroy, ::ActiveStorage::Attachment, record_type: 'Import'
        cannot :read,
               ::ActiveStorage::Attachment,
               record_type: %w[ActiveStorage::VariantRecord ActiveStorage::Blob]
        user
          .role
          .permissions
          .map(&:model)
          .uniq
          .select { can?(:update, _1.safe_constantize) }
          .each { |record_type| can(:destroy, ::ActiveStorage::Attachment, record_type:) }
      end
    end
  end
end
