# frozen_string_literal: true

module Schematics
  module Attributes
    # :reek:SubclassedFromCoreClass
    class Model < String
      include Behaviours::Enumerable

      def available_options = super.excluding(
        Options::Translated,
        Options::Normalization
      )

      def collection = super.sort

      def format(value)
        value
          &.safe_constantize
          &.human_name
          &.humanize || value
      end

      def icon = :project_diagram

      def values = entity
        .schema
        .entities
        .reject(&:hidden?)
        .map(&:class_name)
    end
  end
end
