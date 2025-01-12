# frozen_string_literal: true

module Schematics
  class RoutingController < ApplicationController
    allow_unauthenticated_access

    %i[index show new create edit update delete destroy archive restore duplicate trigger]
      .each do |action|
        define_method(action) { controller_class.dispatch(action, request, response) }
      end

    def controller_name = "::#{params[:model_name].pluralize}Controller"

    def controller_class
      controller_name.safe_constantize || ResourcesController
    end
  end
end
