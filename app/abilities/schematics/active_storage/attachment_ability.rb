# frozen_string_literal: true

module Schematics
  module ActiveStorage
    class AttachmentAbility < ApplicationAbility
      def initialize(user)
        super
        parent_correlation_table.each do |action, permission|
          user
            .role
            .permissions
            .select { _1.action == action.to_s }
            .map(&:model)
            .select(&Object.method(:const_defined?))
            .each { |record_type| can(permission, ::ActiveStorage::Attachment, record_type:) }
        end
        cannot :destroy, ::ActiveStorage::Attachment, record_type: 'Import'
        cannot :read, ::ActiveStorage::Attachment, record_type: 'ActiveStorage::VariantRecord'
      end

      private

      def parent_correlation_table = { update: :destroy, show: :read }
    end
  end
end
