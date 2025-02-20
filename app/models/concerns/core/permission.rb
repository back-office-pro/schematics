# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

# :reek:MissingSafeMethod
module Core
  module Permission
    extend ActiveSupport::Concern

    prepended do
      scope :features, Permissions::FeaturesQuery
    end

    class_methods do
      def create_entities_permissions!
        schema.entities.reject(&:hidden?).flat_map do |entity|
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
      .resources_url(**model_class.route_params, **Tenant.default_url_options)
  end
end
