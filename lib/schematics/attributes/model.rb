# frozen_string_literal: true

module Schematics
  module Attributes
    # :reek:SubclassedFromCoreClass
    class Model < String
      include Behaviours::Enumerable
      include Behaviours::Untranslatable
      include Behaviours::Unnormalizable

      def available_options = super.push(Options::FilterBy)

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
        .reject(&filter_by)
        .map(&:class_name)

      private

      def filter_by = :"#{options.filter_by || 'hidden'}?"
    end
  end
end
