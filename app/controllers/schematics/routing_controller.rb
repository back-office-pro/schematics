# frozen_string_literal: true

module Schematics
  class RoutingController < ApplicationController
    allow_unauthenticated_access

    %i[index show new create edit update delete destroy archive restore duplicate trigger]
      .each do |action|
        define_method(action) { controller_class.dispatch(action, request, response) }
      end

    def controller_class
      "::#{params[:model_name].pluralize}Controller".constantize
    rescue NameError
      ResourcesController
    end
  end
end
