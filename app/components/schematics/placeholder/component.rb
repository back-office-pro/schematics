# frozen_string_literal: true

module Schematics
  module Placeholder
    class Component < ApplicationComponent
      option :visible, default: proc { true }
      option :size, default: proc { 16 }
      option :cols, default: proc { 1 }

      def col_class = "col-#{12 / cols}"

      def css_classes
        'd-none' unless visible?
      end

      def visible? = visible
    end
  end
end
