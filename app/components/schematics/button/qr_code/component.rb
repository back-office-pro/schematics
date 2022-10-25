# frozen_string_literal: true

module Schematics
  module Button
    module QrCode
      class Component < ApplicationComponent
        delegate :class, to: :resource, prefix: :model, private: true
        delegate :entity, to: :model_class, private: true
        delegate :viewer, to: :entity, private: true
        option :resource

        def css_classes = %w[btn btn-sm btn-icon-split ms-2]

        def render?
          viewer != :calendar
        end
      end
    end
  end
end
