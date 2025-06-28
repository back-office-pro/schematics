# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  module Routable
    extend ActiveSupport::Concern

    class_methods do
      def route_params = { resource: human_name_plural.parameterize }
    end

    def route_params = self
      .class
      .route_params
      .merge(id: to_param)

    def default_url_options = { host:, port: }.compact

    private

    def host
      return ::Server.domain if Rails.env.on_premise?

      "#{current_shard}.#{::Server.domain}"
    end

    def port
      ::Server::DEFAULT_PORT if Rails.env.development?
    end
  end
end
