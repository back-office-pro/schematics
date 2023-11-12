# frozen_string_literal: true

module Schematics
  module Behaviours
    module Specifiable
      def to_spec = self
        .class
        .human_attribute_name(:to_spec, **spec_interpolations)

      protected

      def spec_interpolations = { entity_name: entity.name.humanize.downcase }
    end
  end
end
