# frozen_string_literal: true

module Schematics
  module Viewer
    module Association
      class Component < Viewer::Component
        delegate :confirm_data, to: :helpers

        def initialize(resources:, collapsed: false)
          super(resources:)
          @collapsed = collapsed
        end

        def title
          case @resources.first
          when ActiveStorage::Attachment
            @resources
              .first
              .record
              .class
              .human_attribute_name(@resources.first.name, count: @resources.size)
          else
            model_class.model_name.human(count: @resources.size)
          end
        end

        def icon
          case @resources.first
          when ActiveStorage::Attachment
            @resources
              .first
              .record
              .class
              .entity
              .find_field_by_name(@resources.first.name)
              .icon
          else
            super
          end
        end

        def random
          @random ||= SecureRandom.base58
        end

        def collapsed?
          @collapsed
        end
      end
    end
  end
end
