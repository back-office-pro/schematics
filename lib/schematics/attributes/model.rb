# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Attributes
    # :reek:SubclassedFromCoreClass
    class Model < String
      include Behaviours::Enumerable
      include Behaviours::Untranslatable
      include Behaviours::Unnormalizable

      delegate :allow_hidden?, :exclude, to: :options

      def available_options = super.push(
        Options::AllowHidden,
        Options::Exclude
      )

      def collection = super.sort

      def format(value)
        value
          &.safe_constantize
          &.human_name
          &.humanize || value
      end

      def icon = :project_diagram

      def validators = super.merge(inclusion: nil)

      def values = entity
        .schema
        .entities
        .then_tap { _1.reject(&:hidden?) unless allow_hidden? }
        .map(&:class_name)
        .excluding(exclude)
    end
  end
end
