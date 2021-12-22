# frozen_string_literal: true

module Schematics
  module Versionable
    extend ActiveSupport::Concern

    DENYLIST = %i[id created_at updated_at deleted_at lock_version slug].freeze

    included do
      has_paper_trail ignore: DENYLIST + filter_attributes,
                      versions: { class_name: 'Schematics::Version' }
    end

    def unstale
      # TODO: self.paper_trail_event = :revert
      self.lock_version += (self.class.find(id).lock_version - lock_version)
      self
    end

    def unread?
      readable? && !Version.exists?(event: 'read', item: self, user: recipient)
    end

    def readable?
      respond_to?(:recipient)
    end
  end
end
