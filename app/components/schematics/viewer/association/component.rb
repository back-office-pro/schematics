# frozen_string_literal: true

module Schematics
  module Viewer
    module Association
      class Component < Viewer::Component
        with_collection_parameter :resources

        def initialize(resources:, collapsed: false, highlight: nil)
          super(resources:)
          @collapsed = collapsed
          @highlight = highlight
        end

        def title
          case @resources.first
          when ::ActiveStorage::Attachment
            @resources
              .first
              .record
              .class
              .human_attribute_name(@resources.first.name, count: @resources.size)
          else
            model_class.human_name(count: @resources.size).titleize
          end
        end

        def icon
          case @resources.first
          when ::ActiveStorage::Attachment
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

        def id
          @id ||= "collapse-#{SecureRandom.base58}"
        end

        def header_button_css_class
          'collapsed' if @collapsed
        end

        def collapse_css_class
          return if @collapsed

          'show'
        end
      end
    end
  end
end
