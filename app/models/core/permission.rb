# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

# :reek:MissingSafeMethod
class ::Permission < Schematics::ApplicationRecord
  scope :features, ::Core::Permissions::FeaturesQuery

  class << self
    def create_entities_permissions!
      SchemaCache.entities.reject(&:hidden?).flat_map do |entity|
        entity.actions_with_events.map { |action| create!(model: entity.class_name, action:) }
      end
    end
  end

  def model_class
    model.safe_constantize
  end

  def webhook_event
    "#{model.underscore}.#{action}" if %w[index show].exclude?(action)
  end

  def webhook_url = Rails
    .application
    .routes
    .url_helpers
    .resources_url(**model_class.route_params, **default_url_options)
end
