# frozen_string_literal: true

module Schematics
  module Interpolable
    extend ActiveSupport::Concern

    def interpolate(resource)
      suppress(Liquid::SyntaxError) do
        liquid_template.render(
          resource.serialized_json(template: 'show', expand: true),
          { strict_variables: true, strict_filters: true }
        )
      end
    end

    # :reek:UncommunicativeVariableName
    def interpolation_errors
      liquid_template.errors
    rescue Liquid::SyntaxError => e
      [e]
    end

    private

    def liquid_template
      @liquid_template ||= Liquid::Template.parse(content, error_mode: :warn)
    end
  end
end
