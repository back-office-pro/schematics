# frozen_string_literal: true

module Schematics
  module Attributes
    # :reek:SubclassedFromCoreClass
    class Model < String
      include Behaviours::Enumerable

      def collection = super.sort

      def format(value)
        value
          &.safe_constantize
          &.human_name
          &.capitalize || value
      end

      def icon = :project_diagram

      def values = Schema
        .instance
        .entities
        .reject(&:hidden?)
        .map(&:class_name)
    end
  end
end
