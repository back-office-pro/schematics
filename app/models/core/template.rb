# frozen_string_literal: true

class Template < Schematics::ApplicationRecord
  def interpolate(resource)
    liquid_template.render(
      resource.cached_serialized_json.transform_keys(&:underscore).deep_flatten.stringify_keys,
      { strict_variables: true, strict_filters: true }
    )
  rescue Liquid::SyntaxError
    nil
  end

  # :reek:UncommunicativeVariableName
  def interpolation_errors
    liquid_template.errors
  rescue Liquid::SyntaxError => e
    [e]
  end

  private

  memoize def liquid_template
    Liquid::Template.parse(content, error_mode: :warn)
  end
end
