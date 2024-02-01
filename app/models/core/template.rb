# frozen_string_literal: true

class Template < Schematics::ApplicationRecord
  # :reek:UncommunicativeVariableName
  def interpolate(resource)
    content % resource
              .cached_serialized_json
              .transform_keys(&:underscore)
              .deep_flatten
  rescue KeyError => e
    I18n.t('errors.virtuals.name', name: e.key)
  rescue StandardError => e
    e.message
  end
end
