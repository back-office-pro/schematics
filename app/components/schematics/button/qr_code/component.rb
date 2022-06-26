# frozen_string_literal: true

module Schematics
  module Button
    module QrCode
      class Component < ApplicationComponent
        delegate :class, to: :@resource, prefix: :model, private: true
        delegate :human_name, to: :model_class, private: true

        def initialize(resource:)
          super
          @resource = resource
        end

        def css_classes = %w[btn btn-sm btn-icon-split ms-2]

        def filename = "#{human_name.dasherize}-#{@resource.slug}.svg"
      end
    end
  end
end
