# frozen_string_literal: true

module Schematics
  module Behaviours
    module Specifiable
      def to_spec = self
        .class
        .human_attribute_name(
          :to_spec,
          **spec_interpolations.slice(:function, :callback),
          **spec_interpolations
            .compact
            .except(:function, :callback)
            .transform_values(&:humanize)
            .transform_values(&:downcase)
        )

      protected

      def spec_interpolations = { entity_name: entity.name }
    end
  end
end
