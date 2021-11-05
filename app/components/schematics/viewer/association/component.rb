# frozen_string_literal: true

module Schematics
  module Viewer
    module Association
      class Component < Viewer::Component
        delegate :confirm_data, to: :helpers

        def initialize(resources:, collapsed: false)
          super(resources: resources)
          @collapsed = collapsed
        end

        def title
          @resources
            .first
            .record
            .class
            .human_attribute_name(@resources.first.name, count: @resources.size)
        end

        def icon
          @resources
            .first
            .record
            .class
            .entity
            .find_field_by_name(@resources.first.name)
            .icon
        end

        def random
          @random ||= SecureRandom.base58
        end

        def collapsed?
          @collapsed
        end

        def attachment?
          klass == ActiveStorage::Attachment
        end
      end
    end
  end
end
