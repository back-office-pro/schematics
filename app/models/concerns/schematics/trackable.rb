# frozen_string_literal: true

module Schematics
  module Trackable
    extend ActiveSupport::Concern

    DENYLIST = %i[id created_at updated_at deleted_at lock_version slug].freeze

    included do
      has_paper_trail ignore: DENYLIST,
                      skip: hidden_attributes + filter_attributes,
                      on: %i[create update destroy],
                      version: :paper_trail_version,
                      versions: {
                        name: :paper_trail_versions,
                        class_name: 'Schematics::Version'
                      }

      has_many versions_association_name, # rubocop:disable Rails/HasManyOrHasOneDependent
               -> { unscope(where: :item_type).where(item_type: it.class.name) },
               class_name: version_class_name,
               as: :item
    end

    class_methods do
      private

      def hidden_attributes = entity
        .attributes
        .select(&:hidden?)
        .map(&:column_name)
        .map(&:to_sym)
    end

    def unstale
      self.lock_version += (self.class.finder(id).lock_version - lock_version)
      self
    end
  end
end
