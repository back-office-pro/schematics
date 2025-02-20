# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module RouteResolvable
    extend ActiveSupport::Concern

    def resolve_model_name_from_route = current_schema
      .entities
      .filter_map(&:model_class)
      .flat_map(&method(:model_class_localized_routes))
      .reduce(&:merge)
      .fetch(params[:resource]) { raise ActionController::RoutingError, 'Not found' }

    private

    def model_class_localized_routes(model_class)
      I18n.available_locales.to_h do |locale|
        [I18n.with_locale(locale) { model_class.route_params[:resource] }, model_class.to_s]
      end
    end
  end
end
