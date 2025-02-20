# Copyright © 2025 Dev & Software. All rights reserved.
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
