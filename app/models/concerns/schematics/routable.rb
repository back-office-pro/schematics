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

    def default_url_options
      { host:, port: ::Server.port }.compact
    end

    private

    def host
      return current_shard if Rails.env.on_premise?
      return "#{current_shard}.localhost.me" if Rails.env.local?

      "#{current_shard}.#{::Server.domain}"
    end
  end
end
