# frozen_string_literal: true

module Schematics
  module Attributes
    # :reek:SubclassedFromCoreClass
    class Model < String
      include Behaviours::Enumerable
      include Behaviours::Untranslatable
      include Behaviours::Unnormalizable

      delegate :allow_hidden?, to: :options

      def available_options = super.push(Options::AllowHidden)

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
        .then_tap { _1.reject(&:hidden?) unless allow_hidden? }
        .map(&:class_name)
    end
  end
end
