# frozen_string_literal: true

module Schematics
  module Button
    module Add
      class Component < ApplicationComponent
        delegate :human_name, :gender, to: :model_class
        option :model_class
        option :resource, optional: true

        def css_classes = %w[btn btn-primary btn-sm btn-icon-split ms-2]

        def path = new_polymorphic_path([resource, model_class].compact, format: nil)

        def render?
          can?(:new, model_class)
        end
      end
    end
  end
end
