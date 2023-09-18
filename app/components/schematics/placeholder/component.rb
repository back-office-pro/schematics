# frozen_string_literal: true

module Schematics
  module Placeholder
    class Component < ApplicationComponent
      option :visible, default: -> { true }
      option :size, default: -> { 16 }
      option :cols, default: -> { 1 }

      def col_class = "col-#{12 / cols}"

      def css_classes
        'd-none' unless visible?
      end

      def visible? = visible
    end
  end
end
