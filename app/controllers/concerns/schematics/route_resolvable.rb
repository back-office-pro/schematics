# frozen_string_literal: true

module Schematics
  module RouteResolvable
    extend ActiveSupport::Concern

    def resolve_model_name_from_route
      I18n.with_locale(current_user.locale) do
        current_schema
          .entities
          .filter_map(&:model_class)
          .to_h { [it.route_params[:resource], it.to_s] }
          .fetch(params[:resource]) { raise ActionController::RoutingError, 'Not found' }
      end
    end
  end
end
