# frozen_string_literal: true

module Schematics
  module Button
    module Calendar
      class Component < ApplicationComponent
        delegate :class, to: :resource, prefix: :model, private: true
        delegate :entity, to: :model_class, private: true
        delegate :viewers, to: :helpers, private: true
        option :resource

        def css_classes = %w[btn btn-sm btn-icon-split ms-1]

        def render?
          viewers.include?(:calendar)
        end
      end
    end
  end
end
