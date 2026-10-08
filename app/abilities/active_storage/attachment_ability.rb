# frozen_string_literal: true

module ActiveStorage
  class AttachmentAbility < Schematics::ApplicationAbility
    def initialize(user)
      super
      parent_correlation_table.each do |action, permission|
        user
          .role
          .permissions
          .select { it.action == action.to_s }
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
