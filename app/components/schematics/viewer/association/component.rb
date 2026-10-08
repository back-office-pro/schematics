# frozen_string_literal: true

module Schematics
  module Viewer
    module Association
      class Component < Viewer::Component
        delegate :size, to: :resources, private: true
        delegate :reflection,
                 to: :proxy_association,
                 prefix: :association,
                 allow_nil: true,
                 private: true

        with_collection_parameter :resources

        def initialize(resources:, collapsed: true, highlight_text: nil)
          super(resources:)
          @collapsed = collapsed
          @highlight_text = highlight_text
        end

        def display_count
          size >= Loadable::ASSOCIATIONS_LIMIT ? "#{Loadable::ASSOCIATIONS_LIMIT.pred}+" : size
        end

        def collapse_css_class
          return if collapsed?

          'show'
        end

        def collapsed? = @collapsed

        def header_button_css_class
          'collapsed' if collapsed?
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

        memoize def id = "collapse-#{SecureRandom.base58}"

        def title
          case @resources.first
          when ::ActiveStorage::Attachment
            @resources
              .first
              .record
              .class
              .human_attribute_name(@resources.first.name, count: size)
          else
            association_reflection
              &.active_record
              &.human_attribute_name(association_reflection.name, count: size, default:)
              &.humanize || default
          end
        end

        def proxy_association
          @resources.try(:proxy_association)
        end

        private

        def default = model_class
          .human_name(count: size)
          .humanize
      end
    end
  end
end
