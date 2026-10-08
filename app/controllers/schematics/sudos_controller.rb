# frozen_string_literal: true

module Schematics
  class SudosController < ApplicationController
    include Fillable

    def new; end

    def create
      result = Sudos::Create.call(session: current_session, user: current_user, resource_params:)
      respond_with result, location: return_to_path
    end

    private

    def model_class = ::User

    def permitted_params = %i[password]
  end
end
