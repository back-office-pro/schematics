# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Routable
    extend ActiveSupport::Concern

    class_methods do
      def route_params = { resource: I18n.t("activerecord.models.#{name.demodulize.underscore}.other").parameterize(separator: '-') }
    end

    def route_params = self
      .class
      .route_params
      .merge(id: to_param)
  end
end
