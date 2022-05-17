# frozen_string_literal: true

module Schematics
  module Versionable
    extend ActiveSupport::Concern

    DENYLIST = %i[id created_at updated_at deleted_at lock_version slug].freeze

    included do
      has_paper_trail ignore: DENYLIST + hidden_attributes + filter_attributes,
                      versions: { class_name: 'Schematics::Version' }
    end

    class_methods do
      private

      def hidden_attributes
        entity
          .attributes
          .select(&:hidden?)
          .map(&:name)
          .map(&:to_sym)
      end
    end

    # :reek:ManualDispatch
    def readable? = respond_to?(:recipient)

    def unread?
      readable? && !Version.exists?(event: 'show', item: self, user: recipient)
    end

    def unstale
      self.lock_version += (self.class.finder(id).lock_version - lock_version)
      self
    end
  end
end
