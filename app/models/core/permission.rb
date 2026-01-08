# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

# :reek:MissingSafeMethod
class ::Permission < Schematics::ApplicationRecord
  scope :features, ::Core::Permissions::FeaturesQuery

  class << self
    def create_entities_permissions!
      Schematics::SchemaCache.entities.reject(&:hidden?).flat_map do |entity|
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
    .resources_url(**model_class.route_params, **::Configuration.default_url_options)
end
