# frozen_string_literal: true

module Schematics
  module Routable
    extend ActiveSupport::Concern

    class_methods do
      def route_params = { resource: model_name.collection }
    end

    def route_params = self
      .class
      .route_params
      .merge(id: to_param)
  end
end
