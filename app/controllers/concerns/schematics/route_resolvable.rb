# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

module Schematics
  module RouteResolvable
    extend ActiveSupport::Concern

    def resolve_model_name_from_route = SchemaCache
      .entities
      .reject(&:abstract?)
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
