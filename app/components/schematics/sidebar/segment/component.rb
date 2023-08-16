# frozen_string_literal: true

module Schematics
  module Sidebar
    module Segment
      class Component < ApplicationComponent
        delegate :values, :format, to: :@attribute
        with_collection_parameter :attribute

        def initialize(attribute:, model_class:)
          super
          @attribute = attribute
          @model_class = model_class
        end

        def path(value)
          polymorphic_path(@model_class, filter: { @attribute.name => value })
        end

        def css_classes = 'nav-link p-0 m-0 text-truncate'

        def toggled_class
          'd-md-block' unless toggled?
        end

        def render?
          is_active_link?(polymorphic_path(@model_class))
        end

        private

        def toggled?
          preferences(:sidebar_toggled, false)
        end
      end
    end
  end
end
