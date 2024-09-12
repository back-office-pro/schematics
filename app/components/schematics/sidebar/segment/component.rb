# frozen_string_literal: true

module Schematics
  module Sidebar
    module Segment
      class Component < ApplicationComponent
        delegate :preferences_sidebar_toggled, to: :current_user, private: true
        delegate :values, :format, to: :@attribute
        with_collection_parameter :attribute

        def initialize(attribute:, model_class:)
          super
          @attribute = attribute
          @model_class = model_class
        end

        def path(value)
          polymorphic_path(@model_class, filter_key => { @attribute.name => value })
        end

        def css_classes = 'nav-link p-0 m-0 text-truncate'

        def toggled_class
          'd-md-block' unless preferences_sidebar_toggled
        end

        def render?
          is_active_link?(polymorphic_path(@model_class))
        end

        private

        def filter_key = Ransack.options[:search_key]
      end
    end
  end
end
