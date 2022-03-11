# frozen_string_literal: true

module Schematics
  module ActiveStorage
    class AttachmentAbility < ApplicationAbility
      def initialize(user)
        super
        cannot :destroy, ::ActiveStorage::Attachment, record_type: 'Import'
        user
          .role
          .permissions
          .map(&:model)
          .uniq
          .filter { can?(:update, _1.constantize) }
          .each { |record_type| can(:destroy, ::ActiveStorage::Attachment, record_type:) }
      end
    end
  end
end
