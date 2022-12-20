# frozen_string_literal: true

module Schematics
  module ActiveStorage
    class AttachmentAbility < ApplicationAbility
      def initialize(user)
        super
        user
          .role
          .permissions
          .map(&:model)
          .uniq
          .select { can?(:update, _1.safe_constantize) }
          .each { |record_type| can(:destroy, ::ActiveStorage::Attachment, record_type:) }
        cannot :destroy, ::ActiveStorage::Attachment, record_type: 'Import'
      end
    end
  end
end
